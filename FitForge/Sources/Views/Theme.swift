import SwiftUI

/// Palette mirroring the original web app's CSS variables.
enum Theme {
    static let blue = Color(hex: 0x4F8EF7)
    static let green = Color(hex: 0x34C759)
    static let orange = Color(hex: 0xFF9500)
    static let red = Color(hex: 0xFF3B30)
    static let bg = Color(hex: 0xFAFAFA)
    static let card = Color.white
    static let text = Color(hex: 0x1A1A1A)
    static let sub = Color(hex: 0x888888)
    static let inputBg = Color(hex: 0xF0F3F7)
}

extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: alpha
        )
    }
}

/// Soft card container used across the app.
struct CardBackground: ViewModifier {
    var radius: CGFloat = 12
    func body(content: Content) -> some View {
        content
            .background(Theme.card)
            .clipShape(RoundedRectangle(cornerRadius: radius, style: .continuous))
            .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 1)
    }
}

extension View {
    func cardStyle(radius: CGFloat = 12) -> some View {
        modifier(CardBackground(radius: radius))
    }
}
