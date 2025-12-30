//
//  Colors.swift
//  AppCore
//
//  Created by Huseyn Hasanov on 24.11.25.
//

import SwiftUICore

public extension Color {
    
    enum Palette {
        public static let primary = Color.init(.primary) // #D5FF9B33
        
        public static let secondary = Color.init(.secondary) // #BEEB85
        
        public static let border = Color.init(.border) // #799A4C
        
        public static let onBackground = Color.init(.onBackground) // #EAEAEA
        
        public static let black = Color.black // #000000
        
        public static let blackHigh = Color.init(.blackHigh) // #000000 90%
        
        public static let blackDisabled = Color.black.opacity(0.38) // #000000 338%
        
        public static let grayPrimary = Color.init(.grayPrimary) // #D5FF9B33
        
        public static let graySecondary = Color.init(.graySecondary) // #929292
        
        public static let grayTeritary = Color.init(.grayTeritary) // #C8C8C8
        
        public static let grayQuaternary = Color.init(.grayQuaternary) // #F3F3F3
        
        public static let green900 = Color.init(.green900) // #596B41
        
        public static let greenLight = Color.init(.greenLight) // #F2FFE0
        
    }
}
