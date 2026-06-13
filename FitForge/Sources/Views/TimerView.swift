import SwiftUI

struct TimerView: View {
    @StateObject private var model = RestTimerModel()

    private let presets = [30, 60, 90, 120, 180, 300]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                Text("Rest Timer").font(.system(size: 28, weight: .heavy)).padding(.bottom, 12)

                TimerDial(remaining: model.remaining, total: model.duration)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 30)

                HStack(spacing: 12) {
                    Button(action: model.toggle) {
                        Label(model.primaryLabel,
                              systemImage: model.running ? "pause.fill" : "play.fill")
                            .font(.system(size: 16, weight: .semibold))
                            .padding(.vertical, 14).padding(.horizontal, 28)
                            .background(model.running ? Theme.red : Theme.blue)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    }
                    Button(action: model.reset) {
                        Label("Reset", systemImage: "arrow.counterclockwise")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(Color(hex: 0x555555))
                            .padding(.vertical, 14).padding(.horizontal, 28)
                            .background(Theme.card)
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .overlay(RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .stroke(Color(hex: 0xE0E0E0), lineWidth: 2))
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom, 24)

                Text("PRESETS")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Theme.sub)
                    .padding(.bottom, 10)
                FlexibleWrap(spacing: 8, lineSpacing: 8) {
                    ForEach(presets, id: \.self) { p in
                        Button { model.setPreset(p) } label: {
                            Text(formatTime(p))
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(model.duration == p ? .white : Theme.text)
                                .padding(.vertical, 10).padding(.horizontal, 18)
                                .background(model.duration == p ? Theme.blue : Theme.card)
                                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                                .overlay(RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .stroke(model.duration == p ? Theme.blue : Color(hex: 0xE0E0E0)))
                        }
                    }
                }
                .padding(.bottom, 24)

                Text("CUSTOM")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Theme.sub)
                    .padding(.bottom, 10)
                HStack(spacing: 12) {
                    Slider(
                        value: Binding(
                            get: { Double(model.duration) },
                            set: { model.setCustom(Int($0)) }
                        ),
                        in: 10...600, step: 5
                    )
                    Text(formatTime(model.duration))
                        .font(.system(size: 14, weight: .semibold))
                        .frame(width: 50, alignment: .trailing)
                }
            }
            .padding(16)
        }
        .background(Theme.bg)
    }
}

struct TimerDial: View {
    let remaining: Int
    let total: Int

    private var progress: Double {
        total > 0 ? Double(remaining) / Double(total) : 0
    }

    var body: some View {
        ZStack {
            Circle().stroke(Color(hex: 0xEEEEEE), lineWidth: 8)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(Theme.blue, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.3), value: progress)
            VStack(spacing: 2) {
                Text(formatTime(remaining))
                    .font(.system(size: 42, weight: .bold))
                    .monospacedDigit()
                Text("remaining").font(.system(size: 12)).foregroundStyle(Theme.sub)
            }
        }
        .frame(width: 220, height: 220)
    }
}

@MainActor
final class RestTimerModel: ObservableObject {
    @Published var duration = 90
    @Published var remaining = 90
    @Published var running = false

    private var timer: Timer?

    var primaryLabel: String {
        running ? "Pause" : (remaining == 0 ? "Restart" : "Start")
    }

    func toggle() {
        if !running && remaining == 0 { remaining = duration }
        running.toggle()
        timer?.invalidate()
        guard running else { return }
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            Task { @MainActor in
                guard let self else { return }
                if self.remaining <= 1 {
                    self.remaining = 0
                    self.running = false
                    self.timer?.invalidate()
                } else {
                    self.remaining -= 1
                }
            }
        }
    }

    func reset() {
        running = false
        timer?.invalidate()
        remaining = duration
    }

    func setPreset(_ value: Int) {
        duration = value
        remaining = value
        running = false
        timer?.invalidate()
    }

    func setCustom(_ value: Int) {
        duration = value
        if !running { remaining = value }
    }
}
