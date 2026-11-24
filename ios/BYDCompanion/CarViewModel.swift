import Observation
import SwiftUI
import WidgetKit

/// 纯蓝牙模式车辆视图模型：控车指令只走 BLE，不走任何云端。
@MainActor
@Observable
final class CarViewModel {
    /// 乐观状态：本机最后一次指令推定的车辆状态（BLE 会话成功即视作已生效）。
    private(set) var lockClosed = true
    private(set) var trunkOpenState = false
    var pending: Set<Control> = []
    var errorMessage: String?
    var importingKey = false

    let ble = AppServices.shared.ble
    let autoUnlock = AppServices.shared.autoUnlock
    let autoLock = AppServices.shared.autoLock

    /// 小组件/通知交给应用执行的指令。
    func runHandoff() {
        guard let command = CarLinkState.takeHandoff() else { return }
        Task {
            if command.bleControl != nil, ble.hasKey {
                ble.connect()
                var waited = 0
                while ble.state != .ready, waited < 20 {
                    try? await Task.sleep(for: .milliseconds(200))
                    waited += 1
                }
            }
            run(command)
        }
    }

    /// 发送任意指令（小组件/通知触发）。
    func run(_ command: CarCommand) {
        perform(command.control, command)
    }

    func toggleLock() {
        let command: CarCommand = lockClosed ? .unlock : .lock
        perform(.lock, command)
        lockClosed.toggle()
    }

    func toggleTrunk() {
        let command: CarCommand = trunkOpenState ? .trunkClose : .trunkOpen
        perform(.trunk, command)
        trunkOpenState.toggle()
    }

    func honk() {
        perform(.honk, .honk)
    }

    func dismissError() {
        errorMessage = nil
    }

    /// 发送指令：只走蓝牙。成功给触觉反馈，失败给中文错误。
    private func perform(_ control: Control, _ command: CarCommand) {
        guard !pending.contains(control) else { return }
        guard command.worksOverBluetooth else {
            errorMessage = "“\(command.label)”不支持蓝牙直连。"
            return
        }
        pending.insert(control)
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        if control == .lock { autoLock.manualCommandSent() }

        Task {
            defer { pending.remove(control) }
            do {
                let confirmed = try await send(command)
                if confirmed {
                    UINotificationFeedbackGenerator().notificationOccurred(.success)
                    if control == .honk {
                        // 鸣笛期间保持磁贴点亮。
                        try? await Task.sleep(for: .seconds(2.5))
                    }
                } else {
                    UINotificationFeedbackGenerator().notificationOccurred(.error)
                    errorMessage = "车辆未确认“\(command.label)”。请检查车辆。"
                }
            } catch {
                UINotificationFeedbackGenerator().notificationOccurred(.error)
                errorMessage = error.localizedDescription
            }
        }
    }

    /// 只走蓝牙；未就绪时自动等待重连，超时给出中文错误（不回退云端）。
    private func send(_ command: CarCommand) async throws -> Bool {
        if ble.hasKey, ble.state != .ready {
            ble.connect()
            var waited = 0
            while ble.state != .ready, waited < 15 {
                try? await Task.sleep(for: .milliseconds(200))
                waited += 1
            }
        }
        guard ble.state == .ready else {
            throw BleError.notConnected
        }
        guard let control = command.bleControl else {
            throw BleError.notConnected
        }
        let confirmed = try await ble.send(control)
        if confirmed { WidgetCenter.shared.reloadAllTimelines() }
        return confirmed
    }
}

/// 蓝牙未就绪时的错误。
struct BleError: LocalizedError {
    var errorDescription: String? { "蓝牙未连接到车辆。请靠近车辆后重试，或在蓝牙钥匙页查看状态。" }
}
