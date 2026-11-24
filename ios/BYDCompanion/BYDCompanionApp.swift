import SwiftUI
import UIKit
import UserNotifications

@main
struct BYDCompanionApp: App {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate

    var body: some Scene {
        WindowGroup {
            HomeView()
                .preferredColorScheme(.dark)
        }
    }
}

/// Long-lived services, created at launch so a background relaunch by iOS
/// (Bluetooth restore, geofence) finds them ready even with no screen shown.
@MainActor
final class AppServices {
    static let shared = AppServices()

    let ble: BleCarLink
    let autoUnlock: AutoUnlock
    let autoLock: AutoLock

    private init() {
        let ble = BleCarLink()
        let autoUnlock = AutoUnlock(link: ble, otherPhoneLeads: { false })
        self.ble = ble
        self.autoUnlock = autoUnlock
        autoLock = AutoLock(link: ble, cachedStatus: { nil }, otherPhoneLeads: { false })
    }
}

final class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        _ = AppServices.shared
        UNUserNotificationCenter.current().delegate = self
        CarNotifications.registerActions()
        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        AppServices.shared.ble.note("应用退到后台")
        AppServices.shared.ble.refreshWidgetIfStale()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        AppServices.shared.ble.note("应用回到前台")
        AppServices.shared.ble.refreshWidgetIfStale()
    }

    /// The Lock button on a left-unlocked notification: lock through the cloud, then say how it went.
    @MainActor
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        guard response.actionIdentifier == CarNotifications.lockAction else { return }
        let link = AppServices.shared.ble
        link.note("点击了未锁提醒通知的上锁按钮")
        Task { @MainActor in
            do {
                let confirmed = try await link.send(.lock)
                CarNotifications.post(confirmed ? "已上锁。" : "已发送上锁指令，但车辆未确认。请检查车辆。")
            } catch {
                CarNotifications.post("蓝牙上锁失败：蓝牙未连接到车辆。")
            }
        }
    }
}
