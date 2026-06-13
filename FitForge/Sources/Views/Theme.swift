import SwiftUI

/// Chrysler / Art Deco palette — ink-on-cream with brass accents.
enum Deco {
    static let cream = Color(hex: 0xF3EAD7)      // app background
    static let creamDeep = Color(hex: 0xE8DCC1)  // hatched fills
    static let paper = Color(hex: 0xFBF6E9)      // card surface
    static let ink = Color(hex: 0x1A1612)        // primary text / dark surfaces
    static let inkSoft = Color(hex: 0x3A312A)    // secondary text
    static let brass = Color(hex: 0xB8893A)      // primary accent / borders
    static let brassDeep = Color(hex: 0x8A6321)  // strong accent / kickers
    static let brassLight = Color(hex: 0xD4A857) // light accent on dark
    static let gold = Color(hex: 0xC89A3E)       // highlight
    static let line = Color(hex: 0x1A1612, alpha: 0.18)
    static let lineSoft = Color(hex: 0x1A1612, alpha: 0.08)
    static let restTint = Color(hex: 0xB8893A, alpha: 0.08) // completed-set row
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

// MARK: - Typography (bundled Cinzel / Inter / DM Mono)

extension Font {
    /// Cinzel — all-caps Roman display.
    static func display(_ size: CGFloat, _ weight: Weight = .regular) -> Font {
        let name: String
        switch weight {
        case .bold, .heavy, .black: name = "Cinzel-Bold"
        case .semibold, .medium:    name = "Cinzel-SemiBold"
        default:                    name = "Cinzel-Regular"
        }
        return .custom(name, size: size)
    }

    /// Inter — body copy.
    static func bodyText(_ size: CGFloat, _ weight: Weight = .regular) -> Font {
        let name: String
        switch weight {
        case .light, .thin, .ultraLight: name = "Inter-Light"
        case .medium:                    name = "Inter-Medium"
        case .semibold:                  name = "Inter-SemiBold"
        case .bold, .heavy, .black:      name = "Inter-Bold"
        default:                         name = "Inter-Regular"
        }
        return .custom(name, size: size)
    }

    /// DM Mono — kickers / metadata (always uppercase, letter-spaced).
    static func mono(_ size: CGFloat, _ weight: Weight = .regular) -> Font {
        let name: String
        switch weight {
        case .light, .thin, .ultraLight: name = "DMMono-Light"
        case .medium, .semibold, .bold, .heavy, .black: name = "DMMono-Medium"
        default:                         name = "DMMono-Regular"
        }
        return .custom(name, size: size)
    }
}
