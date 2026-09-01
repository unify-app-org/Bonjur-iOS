//
//  UserCardWidgetPalette.swift
//  UnifyWidget
//
//  Created by Huseyn Hasanov on 01.09.26.
//

import SwiftUI

/// The app colors the widget needs, as literals.
///
/// The extension deliberately does not link `AppUIKit` (it would drag SDWebImage and the
/// whole design system into a memory-capped process), so these mirror `Color.Palette` /
/// `Colors.xcassets` — keep the hex values in sync by hand.
enum WidgetPalette {
    /// `appPrimary` #D5FF9B
    static let primary = Color(hex: 0xD5FF9B)
    /// `appSecondary` #BEEB85
    static let secondary = Color(hex: 0xBEEB85)
    /// `cardBgSecondry` #4870FF
    static let cardBgSecondary = Color(hex: 0x4870FF)
    /// `cardBgTeritary` #E6C1FE
    static let cardBgTertiary = Color(hex: 0xE6C1FE)
    /// `cardBgOrange` #FFC144
    static let cardBgOrange = Color(hex: 0xFFC144)
    /// `cardBgRed` #FF5558
    static let cardBgRed = Color(hex: 0xFF5558)
    /// `cardBgPink` #FF9BF8
    static let cardBgPink = Color(hex: 0xFF9BF8)
    /// `grayQuaternary` #F3F3F3
    static let grayQuaternary = Color(hex: 0xF3F3F3)
    /// `grayTeritary` #C8C8C8
    static let grayTertiary = Color(hex: 0xC8C8C8)

    static let blackHigh = Color.black.opacity(0.9)
    static let blackMedium = Color.black.opacity(0.6)
    static let whiteHigh = Color.white.opacity(0.9)
    static let whiteMedium = Color.white.opacity(0.6)
    static let white = Color.white
}

/// Mirror of `AppPresentationModel.BackgroundType` + its `bgColor` / `foregroundColor`
/// extension. Decoded from the raw value the app stores in the snapshot, so the widget
/// wears whatever cover the user picked on the card screen.
enum WidgetCardCover: String {
    case primary = "GREEN"
    case secondary = "BLUE"
    case tertiary = "PURPLE"
    case orange = "ORANGE"
    case red = "RED"
    case pink = "PINK"

    var bgColor: Color {
        switch self {
        case .primary: return WidgetPalette.primary
        case .secondary: return WidgetPalette.cardBgSecondary
        case .tertiary: return WidgetPalette.cardBgTertiary
        case .orange: return WidgetPalette.cardBgOrange
        case .red: return WidgetPalette.cardBgRed
        case .pink: return WidgetPalette.cardBgPink
        }
    }

    var foregroundColor: Color {
        switch self {
        case .tertiary, .primary, .pink, .orange:
            return WidgetPalette.blackHigh
        case .secondary, .red:
            return WidgetPalette.whiteHigh
        }
    }
}

extension Color {
    init(hex: UInt32) {
        self.init(
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255
        )
    }
}
