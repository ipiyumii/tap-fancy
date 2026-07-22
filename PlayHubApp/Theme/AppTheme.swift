
import SwiftUI

struct AppTheme {
    static let primary = Color(hex: "8B5CF6")
    static let primaryDark = Color(hex: "6D28D9")
    static let primaryLight = Color(hex: "A78BFA")

    static let accent = Color(hex: "F97316")
    static let accentLight = Color(hex: "FB923C")
    static let accentDark = Color(hex: "EA580C")

    static let teal = Color(hex: "2DD4BF")
    static let tealLight = Color(hex: "5EEAD4")

    static let background = Color(hex: "0F0D1A")
    static let backgroundPure = Color(hex: "0A0912")
    static let surface = Color(hex: "1A1625")
    static let surfaceLight = Color(hex: "251F36")
    static let surfaceElevated = Color(hex: "2D2640")

    static let textPrimary = Color.white
    static let textSecondary = Color(hex: "A8A3B8")
    static let textMuted = Color(hex: "6B6680")
    static let textOnColor = Color.white 

    static let success = Color(hex: "34D399")
    static let error = Color(hex: "F87171")
    static let warning = Color(hex: "FBBF24")

    static let tapFrenzy = Color(hex: "F97316")
    static let lightItUp = Color(hex: "8B5CF6")
    static let quizRush = Color(hex: "2DD4BF")

    static let primaryGradient = LinearGradient(
        colors: [Color(hex: "8B5CF6"), Color(hex: "6D28D9")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let accentGradient = LinearGradient(
        colors: [Color(hex: "F97316"), Color(hex: "FB923C")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let backgroundGradient = LinearGradient(
        colors: [Color(hex: "1A1625"), Color(hex: "0F0D1A")],
        startPoint: .top,
        endPoint: .bottom
    )

    static let cardGradient = LinearGradient(
        colors: [Color(hex: "251F36"), Color(hex: "1A1625")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let tapFrenzyGradient = LinearGradient(
        colors: [Color(hex: "F97316"), Color(hex: "EA580C")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let lightItUpGradient = LinearGradient(
        colors: [Color(hex: "8B5CF6"), Color(hex: "7C3AED")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let quizRushGradient = LinearGradient(
        colors: [Color(hex: "2DD4BF"), Color(hex: "14B8A6")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let cardShadowColor = Color.black.opacity(0.3)
    static let cardCornerRadius: CGFloat = 16

    static func elevatedCard<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        content()
            .background(surfaceElevated)
            .cornerRadius(cardCornerRadius)
            .shadow(color: cardShadowColor, radius: 12, x: 0, y: 4)
    }

    static let confettiColors: [Color] = [
        accent, primary, teal, primaryLight, Color(hex: "FBBF24")
    ]
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: 
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: 
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: 
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}