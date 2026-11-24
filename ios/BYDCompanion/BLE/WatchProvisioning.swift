import CommonCrypto
import CryptoKit
import CoreImage
import Foundation
import SwiftUI

/// 比亚迪“手表钥匙”扫码配对（App 内置版）。
/// 协议来源：provision_ble_key.py（BydBleAutoLock 移植）+ 控车助手 CN 端点路径。
/// 流程：创建二维码 → 官方 App 扫码授权 → 轮询状态 → 换 token → 拉车辆信息（MAC/dkey/钥匙编号）→ 自动导入。
@MainActor
@Observable
final class WatchProvisioning {
    enum Phase: Equatable {
        case idle
        case creating
        case showingQR
        case waitingApproval
        case importing
        case done
        case failed(String)
    }

    private(set) var phase: Phase = .idle
    private(set) var qrImage: UIImage?
    private(set) var statusText = ""
    private(set) var log: [String] = []

    // CN 服务器（王朝/海洋网）。端点路径与海外版不同（camelCase，来自控车助手二进制）。
    private let baseURL = "https://dilinkwatchapp-cn.byd.auto"
    private let countryCode = "CN"
    private let language = "zh"
    private let timeZone = "Asia/Shanghai"
    private let watchModel = "SM-R925N"
    private let watchBrand = "SAMSUNG"
    private let watchAppVersion = "341"
    private var imei = ""
    private var timeOffsetMS: Int64 = 0
    private var pollTask: Task<Void, Never>?

    private func endpoint(_ key: String) -> String {
        switch key {
        case "time": return "watch/watchApp/login/watchLogin/getServerCurrentTime"
        case "createQR": return "watch/watchApp/login/watchLogin/createQrCode"
        case "checkQR": return "watch/watchApp/login/watchLogin/getQRCodeStatus"
        case "token": return "watch/watchApp/login/watchLogin/getToken"
        case "vehicle": return "watch/watchApp/login/watchLogin/getVehicleInfo"
        case "blueInfo": return "watch/getWatchBlueInfo"
        default: return ""
        }
    }

    // MARK: 加密助手（与官方手表 App 一致）

    private func md5Hex(_ value: String) -> String {
        Insecure.MD5.hash(data: Data(value.utf8)).map { String(format: "%02X", $0) }.joined()
    }

    /// SHA-1，逐字节十六进制：偶数位大写、奇数位小写。
    private func sha1Mixed(_ value: String) -> String {
        let digest = Insecure.SHA1.hash(data: Data(value.utf8))
        return digest.enumerated().map { i, b in
            let hex = String(format: "%x", b)
            return i % 2 == 0 ? hex.uppercased() : hex
        }.joined()
    }

    private func hexBytes(_ hex: String) -> [UInt8]? {
        let chars = Array(hex)
        guard chars.count % 2 == 0 else { return nil }
        var out = [UInt8]()
        out.reserveCapacity(chars.count / 2)
        for i in stride(from: 0, to: chars.count, by: 2) {
            guard let b = UInt8(String(chars[i...i+1]), radix: 16) else { return nil }
            out.append(b)
        }
        return out
    }

    /// AES-128-CBC，IV 全零，PKCS7 填充，输出大写 HEX。
    private func aesEncryptHex(_ plaintext: String, keyHex: String) throws -> String {
        let plain = Data(plaintext.utf8)
        let padded = pkcs7Pad(plain, blockSize: 16)
        return try aesCBC(padded, keyHex: keyHex, encrypt: true).hexUppercased
    }

    /// AES-128-CBC 解密并去 PKCS7，返回 UTF-8 字符串。
    private func aesDecryptString(_ cipherHex: String, keyHex: String) throws -> String {
        guard let cipher = hexBytes(cipherHex), cipher.count % 16 == 0 else { throw Err.badCipher }
        let plain = try aesCBC(Data(cipher), keyHex: keyHex, encrypt: false)
        guard let pad = plain.last, 1 <= Int(pad), Int(pad) <= 16, plain.count >= Int(pad) else { throw Err.badCipher }
        let trimmed = plain.prefix(plain.count - Int(pad))
        guard let text = String(data: Data(trimmed), encoding: .utf8) else { throw Err.badCipher }
        return text
    }

    private func aesCBC(_ input: Data, keyHex: String, encrypt: Bool) throws -> Data {
        guard let key = hexBytes(keyHex), key.count == kCCKeySizeAES128 else { throw Err.badKey }
        let iv = [UInt8](repeating: 0, count: kCCBlockSizeAES128)
        var out = Data(repeating: 0, count: input.count + kCCBlockSizeAES128)
        var moved = 0
        let status = out.withUnsafeMutableBytes { outPtr in
            input.withUnsafeBytes { inPtr in
                CCCrypt(encrypt ? CCOperation(kCCEncrypt) : CCOperation(kCCDecrypt),
                        CCAlgorithm(kCCAlgorithmAES), CCOptions(kCCOptionPKCS7Padding),
                        key, key.count, iv,
                        inPtr.baseAddress, input.count,
                        outPtr.baseAddress, outPtr.count, &moved)
            }
        }
        guard status == kCCSuccess else { throw Err.badCipher }
        return out.prefix(moved)
    }

    private func pkcs7Pad(_ data: Data, blockSize: Int) -> Data {
        let pad = blockSize - (data.count % blockSize)
        return data + Data(repeating: UInt8(pad), count: pad)
    }

    // MARK: 请求封装

    enum Err: LocalizedError {
        case badKey, badCipher, badResponse(String), noDkey
        var errorDescription: String? {
            switch self {
            case .badKey: return "密钥派生失败"
            case .badCipher: return "响应解密失败"
            case .badResponse(let m): return m
            case .noDkey: return "比亚迪未返回蓝牙钥匙（dkey）。请确认车辆/账号已在官方 App 开通蓝牙钥匙功能。"
            }
        }
    }

    private func nowMS() -> String { String(Int64(Date().timeIntervalSince1970 * 1000) + timeOffsetMS) }

    private func compactJSON(_ fields: [String: String]) -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys]
        guard let data = try? encoder.encode(fields) else { return "{}" }
        return String(data: data, encoding: .utf8) ?? "{}"
    }

    private func sign(_ fields: [String: String], secret: String) -> String {
        let parts = fields.sorted { $0.key < $1.key }.map { "\($0.key)=\($0.value)&" }.joined()
        return sha1Mixed(parts + "password=" + md5Hex(secret))
    }

    private func commonOuter(_ ts: String) -> [String: String] {
        ["watchModel": watchModel,
         "watchName": watchBrand + watchModel,
         "watchBrand": watchBrand,
         "watchAppVersion": watchAppVersion,
         "watchOs": "0",
         "reqTimestamp": ts,
         "language": language,
         "countryCode": countryCode]
    }

    private func post(_ endpoint: String, body: [String: String], decryptKey: String) async throws -> [String: Any] {
        guard let url = URL(string: "\(baseURL)/\(endpoint)") else { throw Err.badResponse("URL 无效") }
        var request = URLRequest(url: url, timeoutInterval: 20)
        request.httpMethod = "POST"
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.setValue("okhttp/4.12.0", forHTTPHeaderField: "User-Agent")
        request.httpBody = compactJSON(body).data(using: .utf8)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
            throw Err.badResponse("\(endpoint): HTTP \((response as? HTTPURLResponse)?.statusCode ?? -1)")
        }
        guard let outer = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw Err.badResponse("\(endpoint): 响应不是 JSON")
        }
        let wrapped = (outer["response"] as? String) ?? (outer["respondData"] as? String) ?? "{}"
        guard let envelope = try? JSONSerialization.jsonObject(with: Data(wrapped.utf8)) as? [String: Any] else {
            throw Err.badResponse("\(endpoint): 响应信封不是 JSON")
        }
        if let code = envelope["code"] as? String, code != "0" {
            throw Err.badResponse("\(endpoint): code=\(code) message=\(envelope["message"] ?? "")")
        }
        if let code = envelope["code"] as? Int, code != 0 {
            throw Err.badResponse("\(endpoint): code=\(code) message=\(envelope["message"] ?? "")")
        }
        let payload = (envelope["respondData"] as? String) ?? (envelope["response"] as? String) ?? ""
        guard !payload.isEmpty else { return [:] }
        let decrypted = try aesDecryptString(payload, keyHex: md5Hex(decryptKey))
        guard let json = try? JSONSerialization.jsonObject(with: Data(decrypted.utf8)) as? [String: Any] else {
            throw Err.badResponse("\(endpoint): 解密后数据不是 JSON")
        }
        return json
    }

    private func unlogin(_ endpoint: String, inner: [String: String]) async throws -> [String: Any] {
        let ts = inner["timeStamp"] ?? nowMS()
        let encry = try aesEncryptHex(compactJSON(inner), keyHex: md5Hex(countryCode))
        var signed = inner
        signed.merge(commonOuter(ts)) { a, _ in a }
        signed["identifier"] = countryCode
        signed["watchImei"] = imei
        var body = signed
        body["encryData"] = encry
        body["sign"] = sign(signed, secret: countryCode)
        return try await post(endpoint, body: body, decryptKey: countryCode)
    }

    private func login(_ endpoint: String, token: [String: Any], extra: [String: String]) async throws -> [String: Any] {
        let ts = nowMS()
        let encryToken = token["encryToken"] as? String ?? ""
        let signToken = token["signToken"] as? String ?? ""
        var inner = ["timeStamp": ts,
                     "random": randomID(),
                     "watchImei": imei,
                     "deviceType": "0",
                     "networkType": "wifi"]
        inner.merge(extra) { a, _ in a }
        let encry = try aesEncryptHex(compactJSON(inner), keyHex: md5Hex(encryToken))
        let identifier = (token["identifier"] as? String) ?? (token["userId"] as? String) ?? countryCode
        let userType = token["userType"] as? String ?? ""
        var signed = inner
        signed.merge(commonOuter(ts)) { a, _ in a }
        signed["identifier"] = identifier
        signed["userType"] = userType
        var body: [String: String] = [
            "identifier": identifier,
            "watchImei": imei,
            "userType": userType,
            "encryData": encry,
            "sign": sign(signed, secret: signToken),
        ]
        body.merge(commonOuter(ts)) { a, _ in a }
        return try await post(endpoint, body: body, decryptKey: encryToken)
    }

    private func basic() -> [String: String] {
        ["timeStamp": nowMS(), "random": randomID(), "networkType": "wifi", "version": watchAppVersion]
    }

    private func randomID() -> String {
        UUID().uuidString.replacingOccurrences(of: "-", with: "").uppercased()
    }

    private func note(_ line: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        log.append("\(formatter.string(from: Date())) \(line)")
        if log.count > 40 { log.removeFirst(log.count - 40) }
        statusText = line
    }

    // MARK: 主流程

    private var qrUUID = ""

    func makeQRImage(_ content: String) -> UIImage? {
        guard let filter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        filter.setValue(Data(content.utf8), forKey: "inputMessage")
        filter.setValue("M", forKey: "inputCorrectionLevel")
        guard let output = filter.outputImage else { return nil }
        let scale = 12
        let transformed = output.transformed(by: CGAffineTransform(scaleX: CGFloat(scale), y: CGFloat(scale)))
        let context = CIContext()
        guard let cg = context.createCGImage(transformed, from: transformed.extent) else { return nil }
        return UIImage(cgImage: cg)
    }

    /// 启动扫码配对。成功后回调 BleKey（自动导入）。
    func start(onKey: @escaping (BleKey) -> Void) {
        guard phase == .idle || phase == .done || phase.isFailure else { return }
        imei = UserDefaults.standard.string(forKey: "watch.imei") ?? md5Hex(randomID())
        UserDefaults.standard.set(imei, forKey: "watch.imei")
        phase = .creating
        statusText = "正在创建配对二维码…"
        log = []
        pollTask?.cancel()
        pollTask = Task { [weak self] in
            guard let self else { return }
            do {
                // 1. 时间同步（部分服务器不支持，忽略失败）
                if let data = try? await unlogin(endpoint("time"), inner: basic()) {
                    if let serverMS = (data["serverTime"] as? Int64) ?? (data["serverTime"] as? String).flatMap(Double.init).map(Int64.init) {
                        timeOffsetMS = serverMS - Int64(Date().timeIntervalSince1970 * 1000)
                    }
                }
                // 2. 创建二维码
                let data = try await unlogin(endpoint("createQR"), inner: basic())
                guard let uuid = data["uuid"] as? String else { throw Err.badResponse("createQrCode 未返回 uuid") }
                qrUUID = uuid
                // 3. 二维码内容
                let plain = "watchImei=\(imei)&uuid=\(uuid)&countryCode=\(countryCode)"
                let qrContent = "watchQRCode://" + (try aesEncryptHex(plain, keyHex: md5Hex("watch.bydautolink")))
                self.qrImage = self.makeQRImage(qrContent)
                self.phase = .showingQR
                self.note("二维码已生成，请用官方比亚迪 App 扫码并确认")
                // 4. 轮询授权状态（最长 5 分钟）
                var approved = false
                let deadline = Date().addingTimeInterval(300)
                while Date() < deadline {
                    try Task.checkCancellation()
                    try await Task.sleep(for: .seconds(3))
                    let status = try await unlogin(endpoint("checkQR"), inner: basic().merging(["uuid": uuid]) { a, _ in a })
                    let codeStatus = (status["codeStatus"] ?? status["qrCodeStatus"] ?? status["status"] ?? status["qrStatus"])
                    let s = "\(codeStatus ?? "-")"
                    self.note("配对状态：\(s)")
                    if s == "2" { approved = true; break }
                    if s == "3" || s == "4" { throw Err.badResponse("二维码被拒绝或已过期（状态 \(s)），请重新扫码") }
                }
                guard approved else { throw Err.badResponse("等待授权超时，请重新扫码") }
                self.note("官方 App 已确认，正在获取会话令牌…")
                // 5. 换 token
                let tokenData = try await unlogin(endpoint("token"),
                    inner: ["timeStamp": nowMS(), "uuid": uuid, "timeZone": timeZone])
                guard let token = tokenData["watchTokenInfo"] as? [String: Any] else {
                    throw Err.badResponse("未返回 watchTokenInfo")
                }
                guard let vin = token["vin"] as? String else {
                    throw Err.badResponse("令牌未包含 VIN")
                }
                self.note("已获取令牌，正在拉取车辆信息…")
                // 6. 车辆信息（MAC + dkey）
                var macAddress: String?
                var dkey: String?
                var keyNumber = 0
                if let vehicle = try? await login(endpoint("vehicle"), token: token,
                                                  extra: ["appVersion": "2", "vin": vin]) {
                    let dto = (vehicle["cfVechicle"] as? [String: Any]) ?? [:]
                    let btDto = (dto["watchBluetoothDto"] as? [String: Any]) ?? [:]
                    let info = (btDto["watchBluetoothInfo"] as? [String: Any]) ?? [:]
                    macAddress = (btDto["macAddress"] as? String) ?? (info["macAddress"] as? String)
                    dkey = (info["dkey"] as? String)
                    if let n = (info["keyNumber"] as? Int) ?? (info["keyNumber"] as? String).flatMap(Int.init) { keyNumber = n }
                }
                // 7. 蓝牙钥匙记录（可能有独立接口）
                if let btKey = try? await login(endpoint("blueInfo"), token: token,
                                                extra: ["appVersion": "2", "vin": vin]) {
                    if let dk = btKey["dk"] as? String { dkey = dk }
                    if let n = (btKey["empowerBluetoothKeyNo"] as? Int) ?? (btKey["empowerBluetoothKeyNo"] as? String).flatMap(Int.init) { keyNumber = n }
                    if let m = btKey["bluetoothMacAddress"] as? String, macAddress == nil { macAddress = m }
                }
                guard let finalDkey = dkey, !finalDkey.isEmpty else { throw Err.noDkey }
                self.note("✓ 蓝牙钥匙获取成功（编号 \(keyNumber)），正在导入…")
                let key = BleKey(vin: vin, macAddress: macAddress, dkey: finalDkey,
                                 keyNumber: keyNumber, keyValidTo: nil)
                phase = .done
                onKey(key)
            } catch is CancellationError {
                phase = .idle
            } catch {
                self.note("✗ \(error.localizedDescription)")
                phase = .failed(error.localizedDescription)
            }
        }
    }

    func cancel() {
        pollTask?.cancel()
        pollTask = nil
        phase = .idle
        statusText = ""
    }
}

extension WatchProvisioning.Phase {
    var isFailure: Bool {
        if case .failed = self { return true }
        return false
    }
}

private extension Data {
    var hexUppercased: String { map { String(format: "%02X", $0) }.joined() }
}
