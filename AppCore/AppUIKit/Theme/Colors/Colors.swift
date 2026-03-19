//
//  Colors.swift
//  AppCore
//
//  Created by Huseyn Hasanov on 24.11.25.
//

import SwiftUI

public extension Color {
    
    enum Palette {
        public static let primary = Color.init(.appPrimary) // #D5FF9B33
        
        public static let secondary = Color.init(.appSecondary) // #BEEB85
        
        public static let border = Color.init(.border) // #799A4C
        
        public static let onBackground = Color.init(.onBackground) // #EAEAEA
        
        public static let black = Color.black // #000000
        
        public static let blackHigh = Color.init(.blackHigh) // #000000 90%
        
        public static let blackMedium = Color.black.opacity(0.6) // #000000 60%
        
        public static let blackDisabled = Color.black.opacity(0.38) // #000000 338%
        
        public static let grayPrimary = Color.init(.grayPrimary) // #D5FF9B33
        
        public static let graySecondary = Color.init(.graySecondary) // #929292
        
        public static let grayTeritary = Color.init(.grayTeritary) // #C8C8C8
        
        public static let grayQuaternary = Color.init(.grayQuaternary) // #F3F3F3
        
        public static let green900 = Color.init(.green900) // #596B41
        
        public static let greenLight = Color.init(.greenLight) // #F2FFE0
        
        public static let cardBgSecondry = Color.init(.cardBgSecondry) // #4870FF
        
        public static let cardBgTeritary = Color.init(.cardBgTeritary) // #E6C1FE
        
        public static let cardBgOrange = Color.init(.cardBgOrange) // #FFC144
        
        public static let cardBgPink = Color.init(.cardBgPink) // #FF9BF8
        
        public static let cardBgRed = Color.init(.cardBgRed) // #FF5558
        
        public static let whiteHigh = Color.white.opacity(0.9)
        
        public static let white = Color.white
        
        public static let whiteMedium = Color.white.opacity(0.6)
        
        public static let appBlue = Color.init(.appBlue) // #6D8DFF
        
        public static let destructiveRed = Color.init(.destructiveRed) // #DD362F

    }
}
