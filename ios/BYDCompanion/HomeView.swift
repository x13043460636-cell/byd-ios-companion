import SwiftUI

/// 纯蓝牙模式首页：锁车/后备箱/鸣笛 + 走近自动解锁与离车自动上锁。
struct HomeView: View {
    @State private var model = CarViewModel()
    @State private var showingBluetooth = false
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                header
                content
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .padding(.bottom, 28)
        }
        .scrollIndicators(.hidden)
        .background(Theme.background.ignoresSafeArea())
        .safeAreaInset(edge: .bottom) { errorBanner }
        .onChange(of: scenePhase, initial: true) { _, phase in
            if phase == .active {
                model.ble.connect()
                model.runHandoff()
            }
        }
        .sheet(isPresented: $showingBluetooth) {
            BluetoothSheet(link: model.ble, autoUnlock: model.autoUnlock, autoLock: model.autoLock, importing: model.importingKey) {
                // 纯蓝牙模式：不提供云端导入，钥匙用“手动导入钥匙”表单。
            }
        }
    }

    private var header: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 4) {
                Text("BYD 车伴")
                    .font(.system(size: 12, weight: .semibold))
                    .tracking(1.4)
                    .foregroundStyle(Theme.muted)
                Text("蓝牙控车")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundStyle(Theme.text)
                BluetoothChip(link: model.ble, importing: model.importingKey) {
                    showingBluetooth = true
                }
                .padding(.top, 4)
            }
            Spacer()
        }
    }

    @ViewBuilder
    private var content: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 14) {
                bleModeCard
                statusPill
            }
            Spacer(minLength: 8)
            CarTopView(
                locked: model.lockClosed,
                trunkOpen: model.trunkOpenState,
                windowsOpen: false,
                acOn: false
            )
        }

        LockButton(locked: model.lockClosed, busy: model.pending.contains(.lock),
                   bluetooth: overBluetooth(.lock), action: model.toggleLock)

        LazyVGrid(columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)], spacing: 12) {
            ControlTile(
                title: "后备箱",
                systemImage: "car.side.rear.open",
                detail: model.trunkOpenState ? "已打开" : nil,
                active: model.trunkOpenState,
                busy: model.pending.contains(.trunk),
                bluetooth: overBluetooth(.trunkOpen),
                action: model.toggleTrunk
            )
            ControlTile(
                title: "鸣笛",
                systemImage: "speaker.wave.3.fill",
                detail: model.pending.contains(.honk) ? "鸣笛&闪灯…" : nil,
                active: model.pending.contains(.honk),
                bluetooth: overBluetooth(.honk),
                action: model.honk
            )
        }

        bleFeaturesCard
    }

    /// 纯蓝牙模式说明卡。
    private var bleModeCard: some View {
        HStack(spacing: 6) {
            Image(systemName: "wave.3.right.circle").foregroundStyle(Theme.accent)
            Text("纯蓝牙模式：靠近车辆自动连接并解锁，离车断开自动上锁")
                .font(.system(size: 13))
                .foregroundStyle(Theme.muted)
            Spacer(minLength: 0)
        }
        .padding(12)
        .background(RoundedRectangle(cornerRadius: 12).fill(Theme.card))
        .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Theme.cardBorder))
    }

    /// 乐观锁车状态徽章。
    private var statusPill: some View {
        chip {
            Circle().fill(model.lockClosed ? Theme.accent : Theme.warning).frame(width: 8, height: 8)
            Text(model.lockClosed ? "已上锁（按本机最后一次指令）" : "已解锁（按本机最后一次指令）")
                .font(.system(size: 12))
                .foregroundStyle(Color(hex: 0xC9D1D9))
                .lineLimit(2)
        }
    }

    /// 自动解锁/上锁功能卡，点击打开蓝牙钥匙页配置。
    private var bleFeaturesCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                Image(systemName: "figure.walk")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(Theme.accent)
                    .frame(width: 36, height: 36)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Theme.cardBorder))
                VStack(alignment: .leading, spacing: 2) {
                    Text("走近自动解锁 · 离车自动上锁")
                    Text("在“蓝牙钥匙”里开启并设置距离阈值").font(.footnote).foregroundStyle(.secondary)
                }
                Spacer(minLength: 8)
                Button("设置") { showingBluetooth = true }
                    .font(.system(size: 14, weight: .semibold))
                    .tint(Theme.accent)
            }
            .padding(14)
            .background(RoundedRectangle(cornerRadius: 16, style: .continuous).fill(Theme.card))
            .overlay(RoundedRectangle(cornerRadius: 16, style: .continuous).strokeBorder(Theme.cardBorder))
        }
    }

    private var dim: Double { 1 }

    /// 蓝牙就绪时该指令可以直连发送。
    private func overBluetooth(_ command: CarCommand) -> Bool {
        model.ble.state == .ready && command.worksOverBluetooth
    }

    @ViewBuilder
    private var errorBanner: some View {
        if let message = model.errorMessage {
            HStack(alignment: .top, spacing: 10) {
                Image(systemName: "exclamationmark.triangle.fill").foregroundStyle(Theme.warning)
                Text(message).font(.system(size: 14)).foregroundStyle(Theme.text)
                Spacer(minLength: 0)
                Button {
                    model.dismissError()
                } label: {
                    Text("好").font(.system(size: 14, weight: .semibold))
                }
                .tint(Theme.accent)
            }
            .padding(14)
            .background(RoundedRectangle(cornerRadius: 16, style: .continuous).fill(Theme.raised))
            .overlay(RoundedRectangle(cornerRadius: 16, style: .continuous).strokeBorder(Theme.warning.opacity(0.6)))
            .padding(.horizontal, 20)
            .padding(.bottom, 8)
        }
    }

    private func chip<Content: View>(@ViewBuilder _ content: () -> Content) -> some View {
        HStack(spacing: 6, content: content)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(Capsule().fill(Theme.card))
            .overlay(Capsule().strokeBorder(Theme.cardBorder))
    }
}
