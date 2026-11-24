# BYD iOS Companion — 自建控车 App 实施计划

目标：基于 BYD Companion（SwiftUI 开源 UI）+ BydBleAutoLock（开源 BLE 协议栈，Java）+
Kongche（闭源已脱壳参考实现，CN 车型已实测可用）构建自己的比亚迪蓝牙控车 App。

已验证前提（2026-11-24）：kongche 在用户车上自动解锁/上锁功能正常 → 协议链路成立，
无需真机抓包校准。

## 资产清单
| 资产 | 位置 | 用途 |
|---|---|---|
| BYD Companion 源码 | 本目录（复制自 WorkBuddy） | UI 壳（SwiftUI 卡片式）、Watch 钥匙配对脚本参考 |
| BydBleAutoLock | E:/develop/code/byd-reference/BydBleAutoLock | BLE 协议栈 Java 源码 + 协议文档（WATCH_BLE_FLOW_PROTOCOL.md 等），3186 行 |
| Kongche-priv.ipa | C:/Users/Administrator/AppData/Local/hermes/attachments/ | CN 协议参考（已脱壳，含自测向量） |
| 迪控 wbsk_tables.json | /tmp/dikong_x/assets/byd/（原 APK 内） | 白盒 AES 自定义表 |
| 官方比亚迪 9.16.0 已脱壳 | 微信目录 BYD-iOS_9.16.0_r6-5_autosign.ipa | 官方类接口参考（备用） |

## 关键技术事实
- 帧格式：头 5AA5/5BB5/A55A + 尾 F5FA，CRC8(poly 0x07)，随机交换→认证→READY→控车指令
- BydBleAutoLock 测试向量与 kongche 内嵌向量格式一致（Legacy 通道同源）
- CN 差异点：Wbsk 白盒 AES（自定义 Sbox/Xor 表 + nibble 编解码 + stripPkcs7），
  kongche 的 Wbsk.selfTest 提供已知答案校验
- Watch 配对：dilinkwatchapp-cn.byd.auto，AES-128-CBC IV=0，key=MD5(...)，
  createQrCode → getQRCodeStatus → getToken → getVehicleInfo → getWatchBlueInfo
- BLE 服务 UUID：42590002/42590003/42594420-4155-544F-E0A9-E50E24DCCA9E 等，
  BydBleCentral 按 SERVICE_OLD/NEW/NEW16 自适应

## 里程碑
- [ ] M1 协议移植：Java→Swift 翻译 BydBleCodec/BydBleCrypto/CryptoUtils + Wbsk 白盒 AES
      （表来自 wbsk_tables.json，算法从 kongche 逆向，用 selfTest 向量验证）
- [ ] M2 钥匙配对：provision_ble_key.py 逻辑并入 App 内（WatchQrService 等价实现）
- [ ] M3 骨架 App：BYD Companion UI 砍掉云服务端，接入手动解锁/上锁/后备箱；
      GitHub Actions 编译未签名 ipa → 全能签 → 实车测试手动控车
- [ ] M4 自动引擎：ProximityEngine（RSSI 阈值状态机 + 防抖 + 免打扰时段）+ iBeacon 唤醒
- [ ] M5 打磨：桌面小组件、签到、日志导出

## 构建链
无 Mac：GitHub Actions macos runner 构建（xcodebuild archive → 未签名 ipa artifact）
→ 用户全能签自签安装。GitHub 凭据：x13043460636-cell（凭据管理器有 token）。

## 风险与对策
- Wbsk 算法逆向受阻 → kongche 的 dk 通道或纯 Legacy 通道（KR 流程）先行，抓包对比
- iOS 后台扫描窗口受限 → iBeacon 唤醒（kongche/官方同方案）+ 定位围栏兜底
- 封号风险：蓝牙近场直连不碰云端风控；配对复用官方手表钥匙流程
