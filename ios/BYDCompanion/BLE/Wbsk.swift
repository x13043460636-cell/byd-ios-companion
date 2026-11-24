//
//  Wbsk.swift
//  CN 白盒 AES-256 信封（WBSK）——与 BYD CN App libwbsk_crypto_tool.so 同源
//  按 AwangYes/BYD-re wbsk.js 精确移植，已对 node 生成向量逐字节校验。
//
import Foundation

enum WbskError: Error, LocalizedError {
    case badBase64
    case badEnvelope(String)
    var errorDescription: String? {
        switch self {
        case .badBase64: return "信封 Base64 解码失败"
        case .badEnvelope(let m): return "信封解析失败: \(m)"
        }
    }
}

enum Wbsk {

    struct ParsedKey {
        let keyData: [UInt8]
        let numRounds: Int
        let isDecrypt: Bool
        let blockSize: Int
    }

    // MARK: - 静态密钥（CN 手表/超级 App API 通用）
    static let outerEncryptKey = "4dca015d9f0488cdea45e890de3b9c4d16c9f82e1082e295c8312d34da7214b805bdec33d8473ab04c84a51eebee4fd5efee21ed403a159a083dbb2854c92719d8f24dd3002ce675c4b930fd5f410ebe56d9594532f9c109b7f2dc58eebd83a83cc948fd3dc0b696add8b06d19efa7c8c04d17f60d144d943e21ef4add5af566ef14241de9c3bb03cf9b9d3c5d042caa1fcdf222e02ba7cf577cc70375d0b4e7e3340278e56ddee1a180451b3a04f25fe34f0d1f05ec426b0de801e7d7382ecf2c3ab7be923c2d5ff0c33eaa4c45c71b258045f68bd7ad0f594ff86785611f67f30da78dfa9b427f04d625a2c61e2db62e1fe7d4"
    static let outerDecryptKey = "72ca0163b22e2973656a67ac1ae1490a61133824a0cd235bcfcd6032dba79d3ca51b1c4d1b03068566ff084645dcc9e6e8a28b39c71e72dec3fe4074109a84f5564d3f43f4854fb634bf633dabe218a5b73470dff70b07161b76c74d92bffa15bcb7fa4fc448a0fe83b62c9dd97f36d1d1d7613028041bb1dd328397bbf8c8bf6f81321f5e2d4982761a375bded52a1de198169839fabad771bc677b57f806c1ca385f43627e9a5081c43d7c9d9fa86e7e78cc0a8050a2420a76c842abbe93eb38f2487bdf93087cd24097a16539da2f86feb693432daf8f0618cbf97ffea3a762b7b91050f8634a8d3ceb25ea7d2b3264a77337"
    static let innerEncryptKey = "9fca018f72712b15e23c275ea5e06a92d8b98404cf0bf960955596ff47dd2adf8f9e0c3ca1363e8be88cb6fced211933e5c3484c20c7bc3ae1eb8541027fef4a20b2f302d93582f7f4349fef05c16d389956ae9f2a7aea278fd5232229e38caca017ffbaf5138d2cadbca917b4694fb2882a64809c095387b7353608ca3a17913e5863770465986995c684ea7db01e0c35c69fd169a8e14ec5123beb5b8dad6e1c5198f34ed1c44d5f9b15035673df5953e5e42351f58052c1483fa4cf93c646a396081355a46d5a7e0ce30d54049802829cd78c1a77c7db8f74acb244b73c5147f161ee25bd702112cec97c339a6b3314527d12"
    static let innerDecryptKey = "71ca0160b689febe1c11e07bc8f8cec81decf71b6c3e0be299a35211888c2fb177958e57a6e971d0a874ecb50991786faf3a34b178f13a668bd14b81a82d3f799f6f0c8bd002406c8b6fdd54b3bb30c0c7d27c906dba87decde28717a0874abacf41755646b4a2c06854615ab00ae53136cbea3302b047659e7a42f792a7369fc130d8ffdc114a7a2cf2fa669b9b337905ff58fe3cc40b9b1edf37ebe50d36b3416abbd32837895b8ea1f22b9eab35efd791d9153208630297b8b953a9ca33265854c33959979b9eb1d049326986851170f4b51d151f43a30c6298a8c03503477336b2000c49746181ca30eabded6d3088b7f615"
    static let outerEncryptIv = "91339992399838993130933138923692"
    static let outerDecryptIv = "54cc5558c551c155c4c05cc4c158ca58"
    static let innerEncryptIv = "a8bb9ab895ba95363a81b1949da68184"

    // MARK: - 白盒半字节混合（protXor）
    @inline(__always)
    static func protXor(_ t: [UInt8], _ a: UInt8, _ b: UInt8) -> UInt8 {
        let hi = t[Int(((a >> 4) << 4) ^ (b >> 4))] & 0xF0
        let lo = (t[Int(((a & 0xF) << 4) ^ (b & 0xF))] >> 4) & 0x0F
        return hi | lo
    }

    // MARK: - 密钥 blob 解析（JS 权威：raw[i] ^ raw[i % 3]，i 为原始下标）
    static func parseWbcKey(_ hex: String) -> ParsedKey {
        let raw = Wbsk.hexDecode(hex)
        precondition(raw.count >= 5)
        let mode = raw[0] ^ raw[3]
        var keyData = [UInt8](repeating: 0, count: raw.count - 4)
        for j in 0..<(raw.count - 4) {
            let i = j + 4
            keyData[j] = raw[i] ^ raw[i % 3]
        }
        let bitsTable: [UInt8: Int] = [
            0x00: 0x80, 0x01: 0x80, 0x02: 0xC0, 0x03: 0xC0, 0x04: 0x80, 0x05: 0x80,
            0x06: 0x40, 0x07: 0x40, 0x08: 0xC0, 0x09: 0xC0, 0x0A: 0x80, 0x0B: 0x80,
            0x0C: 0x80, 0x0D: 0x80, 0x0E: 0xC0, 0x0F: 0xC0, 0x10: 0x100, 0x11: 0x100,
            0x12: 0x40, 0x13: 0x40, 0x14: 0xC0, 0x15: 0xC0, 0x16: 0x80, 0x17: 0x80
        ]
        let bits = bitsTable[mode] ?? 0x80
        let numRounds = (bits >> 5) + 6
        return ParsedKey(keyData: keyData,
                         numRounds: numRounds,
                         isDecrypt: mode & 1 == 1,
                         blockSize: (mode == 6 || mode == 7 || mode == 0x12 || mode == 0x13) ? 8 : 16)
    }

    // MARK: - 加密块（每轮 Te0/Te1/Te2/Te3 四次 protXor 累加）
    static func encryptBlock(_ input: [UInt8], _ key: ParsedKey) -> [UInt8] {
        let T = WbskTables.self
        var state = [UInt8](repeating: 0, count: 16)
        for i in 0..<16 { state[i] = protXor(T.encInitXor, input[i], key.keyData[i]) }
        var t1 = [UInt8](repeating: 0, count: 16)
        var t2 = [UInt8](repeating: 0, count: 16)
        let te1i = [5, 9, 13, 1], te2i = [10, 14, 2, 6], te3i = [15, 3, 7, 11]
        for r in 1..<key.numRounds {
            for c in 0..<4 {
                let b = c * 4
                let w = wordBE(T.encTe0, Int(state[b]))
                t1[b] = UInt8((w >> 24) & 0xFF); t1[b+1] = UInt8((w >> 16) & 0xFF)
                t1[b+2] = UInt8((w >> 8) & 0xFF); t1[b+3] = UInt8(w & 0xFF)
            }
            for c in 0..<4 {
                let b = c * 4
                let w = wordBE(T.encTe1, Int(state[te1i[c]]))
                t2[b] = UInt8((w >> 24) & 0xFF); t2[b+1] = UInt8((w >> 16) & 0xFF)
                t2[b+2] = UInt8((w >> 8) & 0xFF); t2[b+3] = UInt8(w & 0xFF)
            }
            for i in 0..<16 { t1[i] = protXor(T.encRoundXor, t1[i], t2[i]) }
            for c in 0..<4 {
                let b = c * 4
                let w = wordBE(T.encTe2, Int(state[te2i[c]]))
                t2[b] = UInt8((w >> 24) & 0xFF); t2[b+1] = UInt8((w >> 16) & 0xFF)
                t2[b+2] = UInt8((w >> 8) & 0xFF); t2[b+3] = UInt8(w & 0xFF)
            }
            for i in 0..<16 { t1[i] = protXor(T.encRoundXor, t1[i], t2[i]) }
            for c in 0..<4 {
                let b = c * 4
                let w = wordBE(T.encTe3, Int(state[te3i[c]]))
                t2[b] = UInt8((w >> 24) & 0xFF); t2[b+1] = UInt8((w >> 16) & 0xFF)
                t2[b+2] = UInt8((w >> 8) & 0xFF); t2[b+3] = UInt8(w & 0xFF)
            }
            for i in 0..<16 { t1[i] = protXor(T.encRoundXor, t1[i], t2[i]) }
            let rk = r * 16
            for i in 0..<16 { state[i] = protXor(T.encRoundXor, t1[i], key.keyData[rk + i]) }
        }
        let sr = [0, 5, 10, 15, 4, 9, 14, 3, 8, 13, 2, 7, 12, 1, 6, 11]
        var out = [UInt8](repeating: 0, count: 16)
        let frk = key.numRounds * 16
        for i in 0..<16 {
            out[i] = protXor(T.encFinalXor, T.encSbox[Int(state[sr[i]])], key.keyData[frk + i])
        }
        return out
    }

    // MARK: - 解密块（Td0-Td3 四次累加 + 逆移位）
    static func decryptBlock(_ input: [UInt8], _ key: ParsedKey) -> [UInt8] {
        let T = WbskTables.self
        var state = [UInt8](repeating: 0, count: 16)
        for i in 0..<16 { state[i] = protXor(T.decInitXor, input[i], key.keyData[i]) }
        var t1 = [UInt8](repeating: 0, count: 16)
        var t2 = [UInt8](repeating: 0, count: 16)
        let td1i = [13, 1, 5, 9], td2i = [10, 14, 2, 6], td3i = [7, 11, 15, 3]
        for r in 1..<key.numRounds {
            for c in 0..<4 {
                let b = c * 4
                let w = wordBE(T.decTd0, Int(state[b]))
                t1[b] = UInt8((w >> 24) & 0xFF); t1[b+1] = UInt8((w >> 16) & 0xFF)
                t1[b+2] = UInt8((w >> 8) & 0xFF); t1[b+3] = UInt8(w & 0xFF)
            }
            for c in 0..<4 {
                let b = c * 4
                let w = wordBE(T.decTd1, Int(state[td1i[c]]))
                t2[b] = UInt8((w >> 24) & 0xFF); t2[b+1] = UInt8((w >> 16) & 0xFF)
                t2[b+2] = UInt8((w >> 8) & 0xFF); t2[b+3] = UInt8(w & 0xFF)
            }
            for i in 0..<16 { t1[i] = protXor(T.decRoundXor, t1[i], t2[i]) }
            for c in 0..<4 {
                let b = c * 4
                let w = wordBE(T.decTd2, Int(state[td2i[c]]))
                t2[b] = UInt8((w >> 24) & 0xFF); t2[b+1] = UInt8((w >> 16) & 0xFF)
                t2[b+2] = UInt8((w >> 8) & 0xFF); t2[b+3] = UInt8(w & 0xFF)
            }
            for i in 0..<16 { t1[i] = protXor(T.decRoundXor, t1[i], t2[i]) }
            for c in 0..<4 {
                let b = c * 4
                let w = wordBE(T.decTd3, Int(state[td3i[c]]))
                t2[b] = UInt8((w >> 24) & 0xFF); t2[b+1] = UInt8((w >> 16) & 0xFF)
                t2[b+2] = UInt8((w >> 8) & 0xFF); t2[b+3] = UInt8(w & 0xFF)
            }
            for i in 0..<16 { t1[i] = protXor(T.decRoundXor, t1[i], t2[i]) }
            let rk = r * 16
            for i in 0..<16 { state[i] = protXor(T.decRoundXor, t1[i], key.keyData[rk + i]) }
        }
        let invSr = [0, 13, 10, 7, 4, 1, 14, 11, 8, 5, 2, 15, 12, 9, 6, 3]
        var out = [UInt8](repeating: 0, count: 16)
        let frk = key.numRounds * 16
        for i in 0..<16 {
            out[i] = protXor(T.decFinalXor, T.decInvSbox[Int(state[invSr[i]])], key.keyData[frk + i])
        }
        return out
    }

    // MARK: - CBC
    static func encryptCBC(_ plaintext: [UInt8], _ key: ParsedKey, _ iv: [UInt8]) -> [UInt8] {
        var out = [UInt8](repeating: 0, count: plaintext.count)
        var prev = iv
        let blocks = plaintext.count / 16
        for b in 0..<blocks {
            var blk = [UInt8](repeating: 0, count: 16)
            for i in 0..<16 { blk[i] = plaintext[b * 16 + i] ^ prev[i] }
            let enc = encryptBlock(blk, key)
            for i in 0..<16 { out[b * 16 + i] = enc[i] }
            prev = enc
        }
        return out
    }

    static func decryptCBC(_ ciphertext: [UInt8], _ key: ParsedKey, _ iv: [UInt8]) -> [UInt8] {
        var out = [UInt8](repeating: 0, count: ciphertext.count)
        var prev = iv
        let blocks = ciphertext.count / 16
        for b in 0..<blocks {
            let blk = Array(ciphertext[b * 16 ..< b * 16 + 16])
            let dec = decryptBlock(blk, key)
            for i in 0..<16 { out[b * 16 + i] = dec[i] ^ prev[i] }
            prev = blk
        }
        return out
    }

    // MARK: - 半字节编解码
    static let nibbleEncodeTable: [UInt8] = [0x0, 0x8, 0x4, 0xC, 0x1, 0x9, 0x5, 0xD, 0x2, 0xA, 0x6, 0xE, 0x3, 0xB, 0x7, 0xF]
    static let nibbleDecodeTable: [UInt8] = [0x0, 0x4, 0x8, 0xC, 0x2, 0x6, 0xA, 0xE, 0x1, 0x5, 0x9, 0xD, 0x3, 0x7, 0xB, 0xF]
    static let mysteryEncodeTable: [UInt8] = [0x4, 0x6, 0x5, 0x7, 0xC, 0xE, 0xD, 0xF, 0x0, 0x2, 0x1, 0x3, 0x8, 0xA, 0x9, 0xB]

    static func nibbleEncode(_ buf: [UInt8]) -> [UInt8] {
        buf.map { (nibbleEncodeTable[Int($0 >> 4)] << 4) | nibbleEncodeTable[Int($0 & 0xF)] }
    }
    static func nibbleDecode(_ buf: [UInt8]) -> [UInt8] {
        buf.map { (nibbleDecodeTable[Int($0 >> 4)] << 4) | nibbleDecodeTable[Int($0 & 0xF)] }
    }
    static func wbcInputEncode(_ buf: [UInt8]) -> [UInt8] {
        buf.map { (mysteryEncodeTable[Int($0 >> 4)] << 4) | mysteryEncodeTable[Int($0 & 0xF)] }
    }
    static func wbcOutputDecode(_ buf: [UInt8]) -> [UInt8] {
        buf.map {
            let hi = nibbleEncodeTable[Int(nibbleEncodeTable[Int($0 >> 4)])]
            let lo = nibbleEncodeTable[Int(nibbleEncodeTable[Int($0 & 0xF)])]
            return (hi << 4) | lo
        }
    }

    // MARK: - 神秘域 PKCS7
    static func addWbcPkcs7(_ buf: [UInt8], blockSize: Int = 16) -> [UInt8] {
        var rem = blockSize - (buf.count % blockSize)
        if rem == 0 { rem = blockSize }
        let pad = (mysteryEncodeTable[rem >> 4] << 4) | mysteryEncodeTable[rem & 0xF]
        return buf + [UInt8](repeating: pad, count: rem)
    }
    static func stripWbcPkcs7(_ buf: [UInt8]) -> [UInt8] {
        guard let last = buf.last, last >= 1, last <= 16, buf.count >= Int(last) else { return buf }
        let n = Int(last)
        if buf.suffix(n).allSatisfy({ $0 == last }) { return Array(buf.dropLast(n)) }
        return buf
    }

    // MARK: - 信封
    static func encryptEnvelope(_ plaintext: String) throws -> String {
        let innerPadded = addWbcPkcs7(wbcInputEncode(Array(plaintext.utf8)))
        let innerKey = parseWbcKey(innerEncryptKey)
        let innerIv = hexDecode(innerEncryptIv)
        let innerEnc = encryptCBC(innerPadded, innerKey, innerIv)
        let innerB64 = Data(wbcOutputDecode(innerEnc)).base64EncodedString()
        let outerPlain = Array(innerB64.utf8) + wbcOutputDecode(innerIv)
        let outerMystery = addWbcPkcs7(wbcInputEncode(outerPlain))
        let outerKey = parseWbcKey(outerEncryptKey)
        let outerIv = hexDecode(outerEncryptIv)
        let outerEnc = encryptCBC(outerMystery, outerKey, outerIv)
        return Data(wbcOutputDecode(outerEnc)).base64EncodedString()
    }

    static func decryptEnvelope(_ b64: String) throws -> String {
        guard let raw = Data(base64Encoded: b64), !raw.isEmpty else { throw WbskError.badBase64 }
        let rawBytes = [UInt8](raw)
        var encoded = nibbleEncode(rawBytes)
        encoded += [UInt8](repeating: 0, count: 256)
        let outerKey = parseWbcKey(outerDecryptKey)
        let outerIv = hexDecode(outerDecryptIv)
        let outerDec = decryptCBC(encoded, outerKey, outerIv)
        let outerContent = stripWbcPkcs7(nibbleDecode(Array(outerDec.prefix(rawBytes.count))))
        guard outerContent.count > 16 else { throw WbskError.badEnvelope("外层内容过短") }
        let contentLen = outerContent.count
        let innerB64 = String(bytes: outerContent.prefix(contentLen - 16), encoding: .isoLatin1) ?? ""
        let innerIv = Array(outerDec[(contentLen - 16) ..< contentLen])
        guard let innerRaw = Data(base64Encoded: innerB64), !innerRaw.isEmpty else {
            throw WbskError.badEnvelope("内层 Base64 解码失败")
        }
        var innerEncoded = nibbleEncode([UInt8](innerRaw))
        innerEncoded += [UInt8](repeating: 0, count: 256)
        let innerKey = parseWbcKey(innerDecryptKey)
        let innerDec = decryptCBC(innerEncoded, innerKey, innerIv)
        let innerContent = stripWbcPkcs7(nibbleDecode(Array(innerDec.prefix(innerRaw.count))))
        guard let s = String(bytes: innerContent, encoding: .utf8) else {
            throw WbskError.badEnvelope("内层明文非 UTF-8")
        }
        return s
    }

    // MARK: - 自检（App 启动时跑一次，结果进最近事件）
    static func structuralSelfTest() -> String? {
        let pt = "{\"appChannel\":\"99\",\"identifier\":\"13800000000\",\"reqTimestamp\":\"1700000000000\"}"
        do {
            let env = try encryptEnvelope(pt)
            let expected = "zvnC6yxWPpMYsA1SwbwfArWaffbEIemK5x4YPlGhQIbuYb8BbM9RBdEzrXaID/eKEa7llVtyBTnD0gR8tpRiNs3B9UEaPx8UAgpEHcC4Tsi8ldKe0efWZ7ZP6Ec7INEjyaG6T6p+tTW4A8PZ5E6WSl63oaCZ0Jli21floKIRfEM="
            if env != expected { return "信封向量不匹配(得到\(env.count)字符)" }
            let rt = try decryptEnvelope(env)
            if rt != pt { return "信封往返失败" }
            return nil
        } catch {
            return "信封自检异常: \(error.localizedDescription)"
        }
    }

    // MARK: - 工具
    static func wordBE(_ table: [UInt8], _ index: Int) -> UInt32 {
        let o = index * 4
        return UInt32(table[o]) << 24 | UInt32(table[o + 1]) << 16 | UInt32(table[o + 2]) << 8 | UInt32(table[o + 3])
    }

    static func hexDecode(_ s: String) -> [UInt8] {
        var bytes = [UInt8]()
        bytes.reserveCapacity(s.count / 2)
        var iter = s.utf8.makeIterator()
        func nib() -> UInt8? {
            guard let c = iter.next() else { return nil }
            switch c {
            case UInt8(ascii: "0")...UInt8(ascii: "9"): return c - UInt8(ascii: "0")
            case UInt8(ascii: "a")...UInt8(ascii: "f"): return c - UInt8(ascii: "a") + 10
            case UInt8(ascii: "A")...UInt8(ascii: "F"): return c - UInt8(ascii: "A") + 10
            default: return nil
            }
        }
        while let hi = nib(), let lo = nib() { bytes.append(hi << 4 | lo) }
        return bytes
    }
}
