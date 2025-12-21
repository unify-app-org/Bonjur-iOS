//
//  FontModel.swift
//  AppCore
//
//  Created by Huseyn Hasanov on 21.12.25.
//

import Foundation
import SwiftUI
import UIKit

public extension AppFonts {
    
    enum Tokens {
        // Font sizes
        public enum FontSize {
            // title
            public static let titleXL: CGFloat = 44
            public static let titleL: CGFloat = 28
            public static let titleMd: CGFloat = 22
            public static let titleSm: CGFloat = 20
            
            // heading
            public static let headingXL: CGFloat = 18
            public static let headingMd: CGFloat = 17
            
            // bodyText
            public static let bodyTextMd: CGFloat = 16
            public static let bodyTextSm: CGFloat = 15
            
            // text
            public static let textL: CGFloat = 14
            public static let textMd: CGFloat = 13
            public static let textSm: CGFloat = 12
            
            // caption
            public static let captionMd: CGFloat = 11
            public static let captionSm: CGFloat = 10
        }
    }

    enum FontName: String {
        case manropeRegular = "Manrope-Regular"
        case manropeMedium = "Manrope-Medium"
        case manropeSemiBold = "Manrope-SemiBold"
        case manropeBold = "Manrope-Bold"
        case manropeExtraBold = "Manrope-ExtraBold"
    }
}
