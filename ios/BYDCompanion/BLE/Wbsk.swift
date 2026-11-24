import Foundation

// MARK: - Wbsk — BYD BLE 白盒 AES（从控车助手 com.devnull.kongche v1.3.0 逆向还原）
//
// 还原来源：
//   - encryptBlock @0x10017296c（见项目 re/encryptBlock.asm）
//   - parseWbcKey  @0x1001721e0（见 re/parseWbcKey.asm）
//   - nibble 辅助表直读自二进制 @0x1003daa38 / @0x1003dab58
//   - 表数据：WbskTables.swift（由迪控 wbsk_tables.json 生成，与 kongche WbskTablesData 同源）
//
// 结构：标准 AES 骨架（T-table + ShiftRows + 自定义 S-box）
//       + 每字节白盒 nibble 交叉混合（nibmix）+ 分段轮密钥。

enum Wbsk {

    // MARK: 错误

    enum Err: LocalizedError {
        case keyTooShort
        case invalidSeed(UInt8)
        case shortInput
        case badPadding

        var errorDescription: String? {
            switch self {
            case .keyTooShort: return "密钥串过短（需 ≥ 5 字符）"
            case .invalidSeed(let s): return "密钥种子校验失败：\(s)"
            case .shortInput: return "输入不足 16 字节"
            case .badPadding: return "PKCS7 填充无效"
            }
        }
    }

    // MARK: 常量

    /// ShiftRows 列索引（还原自二进制 @0x1003daaa0 的 Int 表）
    static let shiftRows: [Int] = [0, 5, 10, 15, 4, 9, 14, 3, 8, 13, 2, 7, 12, 1, 6, 11]

    /// NIBBLE 表 @0x1003daa38（nibble 循环左移）
    static let nibbleDecode: [UInt8] = [0x00, 0x08, 0x04, 0x0C, 0x01, 0x09, 0x05, 0x0D,
                                        0x02, 0x0A, 0x06, 0x0E, 0x03, 0x0B, 0x07, 0x0F]
    /// MYSTERY 表 @0x1003dab58
    static let mysteryEncode: [UInt8] = [0x04, 0x06, 0x05, 0x07, 0x0C, 0x0E, 0x0D, 0x0F,
                                         0x00, 0x02, 0x01, 0x03, 0x08, 0x0A, 0x09, 0x0B]

    /// seed → 配置字（还原自 @0x100262fd0，20 项）
    static let seedConfig: [UInt64] = [
        0x80, 0x80, 0xC0, 0xC0, 0x80, 0x80, 0x40, 0x40,
        0xC0, 0xC0, 0x80, 0x80, 0x80, 0x80, 0xC0, 0xC0,
        0x100, 0x100, 0x40, 0x40,
    ]
    /// parseWbcKey 接受的 seed 集合（位掩码 0x000c00c0）
    static let validSeedMask: UInt32 = 0x000C_00C0

    // MARK: 核心原语

    /// 白盒 nibble 交叉混合（encryptBlock 内反复出现的组合模式）。
    /// a = (x高位 | y高位)；b = (y低位 | x低位)；out = (T[a] 高 nibble) | (T[b] >> 4)
    @inline(__always)
    static func nibmix(_ table: [UInt8], _ x: UInt8, _ y: UInt8) -> UInt8 {
        let a = (x & 0xF0) | (y >> 4)
        let b = ((y & 0x0F) << 4) | (x & 0x0F)
        return ((table[Int(a)] & 0xF0) | (table[Int(b)] >> 4))
    }

    /// put 闭包语义：UInt32 按大端写入 16 字节缓冲的 word p。
    @inline(__always)
    static func putWordBE(_ buffer: inout [UInt8], _ p: Int, _ word: UInt32) {
        buffer[4 * p + 0] = UInt8(truncatingIfNeeded: word >> 24)
        buffer[4 * p + 1] = UInt8(truncatingIfNeeded: word >> 16)
        buffer[4 * p + 2] = UInt8(truncatingIfNeeded: word >> 8)
        buffer[4 * p + 3] = UInt8(truncatingIfNeeded: word)
    }

    @inline(__always)
    static func wordLE(_ table: [UInt8], _ index: Int) -> UInt32 {
        let o = index * 4
        return UInt32(table[o]) | (UInt32(table[o + 1]) << 8) | (UInt32(table[o + 2]) << 16) | (UInt32(table[o + 3]) << 24)
    }

    // MARK: encryptBlock（完整还原）

    /// - Parameters:
    ///   - input: 16 字节明文块
    ///   - keyData: 分段轮密钥，长度 = 16 * (numRounds + 1)
    ///   - numRounds: 轮数（来自 parseWbcKey，生产密钥为 8 或 12）
    static func encryptBlock(_ input: [UInt8], keyData: [UInt8], numRounds: Int) -> [UInt8] {
        precondition(input.count >= 16, "encryptBlock: 输入不足 16 字节")
        precondition(keyData.count >= 16 * (numRounds + 1), "encryptBlock: 轮密钥长度不足")

        var state = [UInt8](repeating: 0, count: 16)
        // ① 初始白盒化
        for i in 0..<16 {
            state[i] = nibmix(WbskTables.encInitXor, input[i], keyData[i])
        }

        // ② 主轮循环 r = 1..<numRounds
        var b = [UInt8](repeating: 0, count: 16)
        var a = [UInt8](repeating: 0, count: 16)
        for r in 1..<max(numRounds, 1) {
            let rk = Array(keyData[16 * r ..< 16 * r + 16])
            // Te0 组（写入 B）
            for p in 0..<4 {
                putWordBE(&b, p, wordLE(WbskTables.encTe0, Int(state[4 * p])))
            }
            // Te1 组（写入 A，对角线 +5）
            for p in 0..<4 {
                putWordBE(&a, p, wordLE(WbskTables.encTe1, Int(state[(4 * p + 5) % 16])))
            }
            // 混合 1
            for i in 0..<16 {
                b[i] = nibmix(WbskTables.encRoundXor, b[i], a[i])
            }
            // Te2 组（写入 A——二进制中此组为死代码，被 Te3 覆盖；保留以精确对齐时序）
            for p in 0..<4 {
                putWordBE(&a, p, wordLE(WbskTables.encTe2, Int(state[(4 * p + 10) % 16])))
            }
            // Te3 组（写入 A，覆盖）
            for p in 0..<4 {
                putWordBE(&a, p, wordLE(WbskTables.encTe3, Int(state[(4 * p + 15) % 16])))
            }
            // 混合 2
            for i in 0..<16 {
                b[i] = nibmix(WbskTables.encRoundXor, b[i], a[i])
            }
            // 轮密钥注入
            for i in 0..<16 {
                state[i] = nibmix(WbskTables.encRoundXor, b[i], rk[i])
            }
        }

        // ③ 末轮：ShiftRows + S-box + 终态混合
        var t = [UInt8](repeating: 0, count: 16)
        for i in 0..<16 {
            t[i] = WbskTables.encSbox[Int(state[shiftRows[i]])]
        }
        let fk = Array(keyData[16 * numRounds ..< 16 * numRounds + 16])
        var out = [UInt8](repeating: 0, count: 16)
        for i in 0..<16 {
            out[i] = nibmix(WbskTables.encFinalXor, t[i], fk[i])
        }
        return out
    }

    // MARK: 密钥解析

    struct ParsedKey {
        let keyData: [UInt8]
        let numRounds: Int
        let seed: UInt8
    }

    /// 还原自 parseWbcKey @0x1001721e0：
    ///   seed = key[0] ^ key[3]，必须 ∈ {6, 7, 14, 15}
    ///   keyData[i] = key[4+i] ^ key[i % 3]
    ///   numRounds = (seedConfig[seed] >> 5) + 6
    static func parseWbcKey(_ keyString: String) throws -> ParsedKey {
        let data = Array(keyString.utf8)
        guard data.count >= 5 else { throw Err.keyTooShort }
        let seed = UInt8(data[0] ^ data[3])
        guard seed <= 0x13, validSeedMask & (1 << seed) != 0 else {
            throw Err.invalidSeed(seed)
        }
        var keyData = [UInt8]()
        keyData.reserveCapacity(data.count - 4)
        for i in 0..<(data.count - 4) {
            keyData.append(UInt8(data[4 + i]) ^ UInt8(data[i % 3]))
        }
        let cfg = seedConfig[Int(seed)]
        let numRounds = Int(cfg >> 5) + 6
        return ParsedKey(keyData: keyData, numRounds: numRounds, seed: seed)
    }

    // MARK: 白盒包络（wbcInputEncode / wbcOutputDecode / nibble 编解码）

    /// nibbleEncode：每字节高低 nibble 分别查 NIBBLE 表
    static func nibbleEncode(_ input: [UInt8]) -> [UInt8] {
        input.map { (nibbleDecode[Int($0 >> 4)] << 4) | nibbleDecode[Int($0 & 0x0F)] }
    }

    /// nibbleDecode：与 encode 逆过程（对 NIBBLE 表求逆查表）
    static func nibbleDecodeBytes(_ input: [UInt8]) -> [UInt8] {
        var inv = [UInt8](repeating: 0, count: 16)
        for i in 0..<16 { inv[Int(nibbleDecode[i])] = UInt8(i) }
        return input.map { (inv[Int($0 >> 4)] << 4) | inv[Int($0 & 0x0F)] }
    }

    /// wbcInputEncode：MYSTERY 表 nibble 替换（加密入口）
    static func wbcInputEncode(_ input: [UInt8]) -> [UInt8] {
        input.map { (mysteryEncode[Int($0 >> 4)] << 4) | mysteryEncode[Int($0 & 0x0F)] }
    }

    /// wbcOutputDecode：NIBBLE 表双重替换（加密出口；与二进制 @0x1001737a4 一致）
    static func wbcOutputDecode(_ input: [UInt8]) -> [UInt8] {
        input.map {
            let hi = nibbleDecode[Int(nibbleDecode[Int($0 >> 4)])]
            let lo = nibbleDecode[Int(nibbleDecode[Int($0 & 0x0F)])]
            return (hi << 4) | lo
        }
    }

    /// PKCS7 填充（块大小 16）
    static func addPkcs7(_ input: [UInt8], blockSize: Int = 16) -> [UInt8] {
        let pad = blockSize - (input.count % blockSize)
        return input + [UInt8](repeating: UInt8(pad), count: pad)
    }

    /// 去 PKCS7 填充（还原自 stripPkcs7：校验末字节并逐字节验证）
    static func stripPkcs7(_ input: [UInt8]) throws -> [UInt8] {
        guard let last = input.last, last >= 1, last <= 16, input.count >= Int(last) else {
            throw Err.badPadding
        }
        let pad = Int(last)
        guard input.suffix(pad).allSatisfy({ $0 == last }) else { throw Err.badPadding }
        return Array(input.dropLast(pad))
    }

    // MARK: CBC

    /// 加密 CBC（IV 处理按标准 CBC 假设：P[0]⊕IV 后逐块链接——待与 encryptCbc.asm 复核）
    static func encryptCBC(_ plaintext: [UInt8], keyData: [UInt8], numRounds: Int, iv: [UInt8]) throws -> [UInt8] {
        guard iv.count == 16 else { throw Err.shortInput }
        let padded = addPkcs7(plaintext)
        var prev = iv
        var out = [UInt8]()
        out.reserveCapacity(padded.count)
        for chunk in stride(from: 0, to: padded.count, by: 16) {
            let block = Array(padded[chunk ..< chunk + 16])
            let xored = zip(block, prev).map { $0 ^ $1 }
            let enc = encryptBlock(xored, keyData: keyData, numRounds: numRounds)
            out.append(contentsOf: enc)
            prev = enc
        }
        return out
    }

    /// encode（还原自 encode @0x100173878 的主路径）：
    /// wbcInputEncode → addPkcs7 → parseWbcKey → encryptCBC → wbcOutputDecode
    static func encode(_ plaintext: [UInt8], keyString: String, iv: [UInt8]) throws -> [UInt8] {
        let prepared = wbcInputEncode(plaintext)
        let padded = addPkcs7(prepared)
        let parsed = try parseWbcKey(keyString)
        let cipher = try encryptCBC(padded, keyData: parsed.keyData, numRounds: parsed.numRounds, iv: iv)
        return wbcOutputDecode(cipher)
    }

    // MARK: 自检

    /// 结构自检：表完整性 + 加解密往返（decrypt 侧实现后启用）
    static func structuralSelfTest() -> [String] {
        var results = [String]()
        // 表尺寸
        let sizesOK = WbskTables.encTe0.count == 1024 && WbskTables.encSbox.count == 256 &&
            WbskTables.encInitXor.count == 256 && WbskTables.encFinalXor.count == 256
        results.append(sizesOK ? "表尺寸: PASS" : "表尺寸: FAIL")
        // nibmix 双射性（固定 y 遍历 x 无碰撞）
        var seen = Set<UInt8>()
        for x in 0..<256 { seen.insert(nibmix(WbskTables.encInitXor, UInt8(x), 0x37)) }
        results.append(seen.count == 256 ? "nibmix 单侧双射: PASS" : "nibmix 单侧双射: FAIL(\(seen.count))")
        // seed 校验
        do {
            _ = try parseWbcKey("0006abc") // seed = '0'^'6' = 6 ✓
            results.append("parseWbcKey seed=6: PASS")
        } catch {
            results.append("parseWbcKey seed=6: FAIL \(error)")
        }
        do {
            _ = try parseWbcKey("abcdx") // seed = 'a'^'d' = 5 ✗
            results.append("parseWbcKey seed=5 拒绝: FAIL(未抛错)")
        } catch {
            results.append("parseWbcKey seed=5 拒绝: PASS")
        }
        return results
    }
}
