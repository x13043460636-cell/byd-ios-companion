import SwiftUI

/// Small pill: a Bluetooth icon, with a label only while the car is reachable over Bluetooth.
struct BluetoothChip: View {
    let link: BleCarLink
    var importing = false
    let action: () -> Void

    private var active: Bool { link.state == .ready }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                BluetoothRune()
                    .stroke(active ? Theme.accent : Theme.muted, style: StrokeStyle(lineWidth: 1.6, lineCap: .round, lineJoin: .round))
                    .frame(width: 8, height: 13)
                if active {
                    Text("蓝牙")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(Color(hex: 0xC9D1D9))
                        .lineLimit(1)
                }
            }
            .padding(.horizontal, active ? 10 : 9)
            .padding(.vertical, 6)
        }
        .buttonStyle(RaisedButtonStyle(active: active, cornerRadius: 14))
        .accessibilityLabel("蓝牙")
        .accessibilityValue(link.hasKey ? link.state.label : "Key not set up")
        .accessibilityHint("Shows Bluetooth details")
    }
}

/// Details: state, recent events, and key management.
struct BluetoothSheet: View {
    let link: BleCarLink
    @Bindable var autoUnlock: AutoUnlock
    @Bindable var autoLock: AutoLock
    var importing: Bool
    let importKey: () -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var showingIntro = false

    var body: some View {
        NavigationStack {
            List {
                Section {
                    LabeledContent("状态", value: link.hasKey ? link.state.label : "未导入钥匙")
                    if link.hasKey {
                        if [.searching, .connecting, .authenticating].contains(link.state) {
                            Button("停止搜索车辆", action: link.stop)
                        } else {
                            Button("重新连接") { link.disconnect(); link.connect() }
                        }
                        Button("删除蓝牙钥匙", role: .destructive) { link.removeKey() }
                    } else {
                        ManualKeyEntry { key in
                            do { try link.installKey(key) } catch { }
                        }
                    }
                } footer: {
                    Text("在车辆附近时，解锁/上锁/后备箱/鸣笛走蓝牙直连；其余功能走比亚迪云端。")
                }
                if link.hasKey {
                    autoUnlockSection
                    autoLockSection
                }
                Section("最近事件") {
                    if link.log.isEmpty {
                        Text("暂无数据").foregroundStyle(.secondary)
                    }
                    ForEach(Array(link.log.enumerated().reversed()), id: \.offset) { _, line in
                        Text(line).font(.system(size: 13, design: .monospaced))
                    }
                }
            }
            .navigationTitle("蓝牙钥匙")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { Button("完成") { dismiss() } }
        }
        .presentationDetents([.medium, .large])
        .sheet(isPresented: $showingIntro) {
            AutoUnlockIntro {
                showingIntro = false
                autoUnlock.enable()
            } cancel: {
                showingIntro = false
            }
        }
        .task {
            // Live signal strength while the sheet is open, to help pick a distance.
            while !Task.isCancelled {
                link.readRSSI()
                try? await Task.sleep(for: .seconds(1))
            }
        }
    }

    private var autoUnlockSection: some View {
        Section {
            HStack(spacing: 12) {
                Image(systemName: "figure.walk")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(Theme.accent)
                    .frame(width: 36, height: 36)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Theme.cardBorder))
                VStack(alignment: .leading, spacing: 2) {
                    Text("走近时自动解锁")
                    Text(autoUnlockSubtitle).font(.footnote).foregroundStyle(.secondary)
                }
                Spacer(minLength: 8)
                Toggle("Unlock as I walk up", isOn: Binding(
                    get: { autoUnlock.isOn },
                    set: { on in
                        if !on {
                            autoUnlock.disable()
                        } else if autoUnlock.authorization == .authorizedAlways {
                            autoUnlock.enable()
                        } else {
                            showingIntro = true
                        }
                    }
                ))
                .labelsHidden()
                .tint(Theme.accent)
            }

            if autoUnlock.isOn {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("解锁距离")
                        Spacer()
                        Text("≈ \(AutoUnlock.label(autoUnlock.distance))").fontWeight(.semibold).foregroundStyle(Theme.accent)
                    }
                    Picker("Unlock distance", selection: $autoUnlock.distance) {
                        ForEach(AutoUnlock.distances, id: \.self) { Text(AutoUnlock.label($0)).tag($0) }
                    }
                    .pickerStyle(.segmented)
                    Text("为估算值。若解锁太迟请调大距离。")
                        .font(.footnote).foregroundStyle(.secondary)
                    signalNow
                }
                .padding(.vertical, 4)
                HStack(spacing: 6) {
                    Text("定位权限")
                    Spacer()
                    Image(systemName: "checkmark")
                        .font(.footnote.weight(.bold))
                        .foregroundStyle(Theme.accent)
                    Text("始终允许").foregroundStyle(.secondary)
                }
            } else if autoUnlock.needsAlways {
                VStack(alignment: .leading, spacing: 10) {
                    Label("需要将定位权限设为“始终允许”。", systemImage: "exclamationmark.triangle")
                        .font(.subheadline)
                        .symbolRenderingMode(.multicolor)
                    Button("打开设置", action: autoUnlock.openSettings)
                        .fontWeight(.semibold)
                }
                .padding(.vertical, 4)
            }
        } header: {
            Text("走近自动解锁")
        } footer: {
            Text("仅在离开后返回时触发。仅蓝牙生效。")
        }
    }

    /// Live signal; in demo mode a long press steps it down.
    @ViewBuilder private var signalNow: some View {
        if let rssi = link.rssi {
            Text("Signal now: \(rssi) dBm")
                .font(.footnote.monospacedDigit())
                .foregroundStyle(.secondary)
                .onLongPressGesture {
                    guard AppConfig.demo else { return }
                    link.demoSignal = link.demoSignal <= -88 ? -58 : link.demoSignal - 10
                }
        }
    }

    private var autoLockSection: some View {
        Section {
            HStack(spacing: 12) {
                Image(systemName: "lock.fill")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(Theme.accent)
                    .frame(width: 36, height: 36)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Theme.cardBorder))
                VStack(alignment: .leading, spacing: 2) {
                    Text("离车时自动上锁")
                    Text(autoLock.isOn ? "On · beyond about \(AutoUnlock.label(autoLock.distance))" : "Off")
                        .font(.footnote).foregroundStyle(.secondary)
                }
                Spacer(minLength: 8)
                Toggle("Lock as I walk away", isOn: Binding(
                    get: { autoLock.isOn },
                    set: { $0 ? autoLock.enable() : autoLock.disable() }
                ))
                .labelsHidden()
                .tint(Theme.accent)
            }

            if autoLock.isOn {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("上锁距离")
                        Spacer()
                        Text("≈ \(AutoUnlock.label(autoLock.distance))").fontWeight(.semibold).foregroundStyle(Theme.accent)
                    }
                    Picker("Lock distance", selection: $autoLock.distance) {
                        ForEach(AutoLock.distances, id: \.self) { Text(AutoUnlock.label($0)).tag($0) }
                    }
                    .pickerStyle(.segmented)
                    Text("为估算值。若上锁太迟请调大距离。")
                        .font(.footnote).foregroundStyle(.secondary)
                    signalNow
                    Text(autoLock.statusText)
                        .font(.footnote.monospacedDigit())
                        .foregroundStyle(Theme.accent)
                }
                .padding(.vertical, 4)
            }
        } header: {
            Text("离车自动上锁")
        } footer: {
            Text("走近超过设定距离数秒后触发。仅蓝牙生效；车辆上电或车门打开时不触发。")
        }
    }

    private var autoUnlockSubtitle: String {
        guard autoUnlock.isOn else { return "Off" }
        guard autoUnlock.carLocation != nil else { return "On · connect once to learn where it's parked" }
        return "On · within about \(AutoUnlock.label(autoUnlock.distance))"
    }
}

/// Explains why auto-unlock needs Always location, before iOS asks.
struct AutoUnlockIntro: View {
    let proceed: () -> Void
    let cancel: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 22) {
            Image(systemName: "lock.open")
                .font(.system(size: 26, weight: .semibold))
                .foregroundStyle(Theme.accent)
                .frame(width: 56, height: 56)
                .background(RoundedRectangle(cornerRadius: 18).fill(Theme.accent.opacity(0.15)))
                .overlay(RoundedRectangle(cornerRadius: 18).strokeBorder(Theme.accent))
            VStack(alignment: .leading, spacing: 8) {
                Text("走近时自动解锁").font(.system(size: 24, weight: .bold))
                (Text("为此，需要将本应用定位权限设为 ") + Text("始终允许").bold() + Text("."))
                    .foregroundStyle(Color(hex: 0xC9D1D9))
            }
            VStack(alignment: .leading, spacing: 14) {
                point("mappin.and.ellipse", "Wakes up near the car.", "iOS tells the app when you get close to where the car is parked, even if the app is closed.")
                point("wifi", "Unlocks only when you're close.", "Bluetooth checks you're within the distance you choose, after you've been away.")
                point("checkmark.shield", "Stays on your iPhone.", "Your location is never sent anywhere.")
            }
            Spacer(minLength: 0)
            VStack(spacing: 10) {
                Button(action: proceed) {
                    Text("继续").font(.system(size: 17, weight: .semibold)).frame(maxWidth: .infinity, minHeight: 52)
                }
                .buttonStyle(.borderedProminent)
                .tint(Theme.accent)
                .foregroundStyle(Theme.background)
                Button("暂不", action: cancel)
                    .frame(maxWidth: .infinity, minHeight: 44)
                    .foregroundStyle(Color(hex: 0xC9D1D9))
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 28)
        .padding(.bottom, 12)
        .presentationDetents([.large])
        .presentationBackground(Color(hex: 0x161B20))
        .preferredColorScheme(.dark)
    }

    private func point(_ icon: String, _ title: String, _ detail: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(Theme.accent)
                .frame(width: 24)
            (Text(title).bold().foregroundColor(Theme.text) + Text(" " + detail).foregroundColor(Color(hex: 0xC9D1D9)))
                .font(.system(size: 15))
        }
    }
}


// MARK: - 手动导入蓝牙钥匙（纯蓝牙模式：dkey 由 provision_ble_key.py 在本地获取）

struct ManualKeyEntry: View {
    let onInstall: (BleKey) -> Void
    @State private var vin = ""
    @State private var macAddress = ""
    @State private var dkey = ""
    @State private var keyNumber = "1"
    @State private var installError: String?
    @FocusState private var focused: Bool

    var body: some View {
        Section("手动导入钥匙（扫码配对获取 dkey 后填入）") {
            TextField("VIN（选填）", text: $vin)
                .textInputAutocapitalization(.characters)
                .autocorrectionDisabled()
            TextField("车辆蓝牙 MAC（选填，如 AA:BB:CC:DD:EE:FF）", text: $macAddress)
                .textInputAutocapitalization(.characters)
                .autocorrectionDisabled()
            TextField("dkey（16 进制串）", text: $dkey)
                .textInputAutocapitalization(.characters)
                .autocorrectionDisabled()
                .font(.system(size: 13, design: .monospaced))
            TextField("钥匙编号", text: $keyNumber)
                .keyboardType(.numberPad)
            if let installError {
                Text(installError).font(.footnote).foregroundStyle(.red)
            }
            Button("导入并连接") {
                let trimmed = dkey.trimmingCharacters(in: .whitespacesAndNewlines)
                guard !trimmed.isEmpty else {
                    installError = "dkey 不能为空"
                    return
                }
                let number = Int(keyNumber) ?? 1
                let key = BleKey(vin: vin.trimmingCharacters(in: .whitespaces),
                                 macAddress: macAddress.trimmingCharacters(in: .whitespaces).isEmpty
                                     ? nil : macAddress.trimmingCharacters(in: .whitespaces).uppercased(),
                                 dkey: trimmed.uppercased(),
                                 keyNumber: number,
                                 keyValidTo: nil)
                onInstall(key)
                installError = nil
            }
            .disabled(dkey.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
    }
}
