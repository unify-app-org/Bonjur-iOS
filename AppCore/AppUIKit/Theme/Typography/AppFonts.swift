//
//  AppFonts.swift
//  AppCore
//
//  Created by Huseyn Hasanov on 21.12.25.
//


import SwiftUI
import UIKit
import CoreText

final class AppUIKitBundle { }

public struct AppFonts {
    
    public init() {
        let resolvedBundle = Bundle(for: AppUIKitBundle.self)
        if let fontURLs = resolvedBundle.urls(forResourcesWithExtension: "ttf", subdirectory: nil) {
            for fontURL in fontURLs {
                CTFontManagerRegisterFontsForURL(fontURL as CFURL, .process, nil)
            }
        }
    }
}

// MARK: - Font namespace
public enum Font {
    
    public enum Typography {
        
        // MARK: - TitleXL (44px)
        /// font sizs 44px
        public enum TitleXl {
            public static var extraBold: SwiftUI.Font {
                SwiftUI.Font.custom(
                    AppFonts.FontName.manropeExtraBold.rawValue,
                    size: AppFonts.Tokens.FontSize.titleXL
                )
            }
            
            public static var regular: SwiftUI.Font {
                SwiftUI.Font.custom(
                    AppFonts.FontName.manropeRegular.rawValue,
                    size: AppFonts.Tokens.FontSize.titleXL
                )
            }
        }
        
        // MARK: - TitleL (28px)
        /// font sizs 28px
        public enum TitleL {
            public static var extraBold: SwiftUI.Font {
                SwiftUI.Font.custom(
                    AppFonts.FontName.manropeExtraBold.rawValue,
                    size: AppFonts.Tokens.FontSize.titleL
                )
            }
            
            public static var bold: SwiftUI.Font {
                SwiftUI.Font.custom(
                    AppFonts.FontName.manropeBold.rawValue,
                    size: AppFonts.Tokens.FontSize.titleL
                )
            }
            
            public static var semiBold: SwiftUI.Font {
                SwiftUI.Font.custom(
                    AppFonts.FontName.manropeSemiBold.rawValue,
                    size: AppFonts.Tokens.FontSize.titleL
                )
            }
            
            public static var medium: SwiftUI.Font {
                SwiftUI.Font.custom(
                    AppFonts.FontName.manropeMedium.rawValue,
                    size: AppFonts.Tokens.FontSize.titleL
                )
            }
            
            public static var regular: SwiftUI.Font {
                SwiftUI.Font.custom(
                    AppFonts.FontName.manropeRegular.rawValue,
                    size: AppFonts.Tokens.FontSize.titleL
                )
            }
        }
        
        // MARK: - TitleMd (22px)
        /// font sizs 22px
        public enum TitleMd {
            public static var bold: SwiftUI.Font {
                SwiftUI.Font.custom(
                    AppFonts.FontName.manropeBold.rawValue,
                    size: AppFonts.Tokens.FontSize.titleMd
                )
            }
            
            public static var semiBold: SwiftUI.Font {
                SwiftUI.Font.custom(
                    AppFonts.FontName.manropeSemiBold.rawValue,
                    size: AppFonts.Tokens.FontSize.titleMd
                )
            }
            
            public static var medium: SwiftUI.Font {
                SwiftUI.Font.custom(
                    AppFonts.FontName.manropeMedium.rawValue,
                    size: AppFonts.Tokens.FontSize.titleMd
                )
            }
            
            public static var regular: SwiftUI.Font {
                SwiftUI.Font.custom(
                    AppFonts.FontName.manropeRegular.rawValue,
                    size: AppFonts.Tokens.FontSize.titleMd
                )
            }
        }
        
        // MARK: - TitleSm (20px)
        /// font sizs 20px
        public enum TitleSm {
            public static var bold: SwiftUI.Font {
                SwiftUI.Font.custom(
                    AppFonts.FontName.manropeBold.rawValue,
                    size: AppFonts.Tokens.FontSize.titleSm
                )
            }
            
            public static var semiBold: SwiftUI.Font {
                SwiftUI.Font.custom(
                    AppFonts.FontName.manropeSemiBold.rawValue,
                    size: AppFonts.Tokens.FontSize.titleSm
                )
            }
            
            public static var medium: SwiftUI.Font {
                SwiftUI.Font.custom(
                    AppFonts.FontName.manropeMedium.rawValue,
                    size: AppFonts.Tokens.FontSize.titleSm
                )
            }
            
            public static var regular: SwiftUI.Font {
                SwiftUI.Font.custom(
                    AppFonts.FontName.manropeRegular.rawValue,
                    size: AppFonts.Tokens.FontSize.titleSm
                )
            }
        }
        
        // MARK: - HeadingXl (18px)
        /// font sizs 18px
        public enum HeadingXl {
            public static var bold: SwiftUI.Font {
                SwiftUI.Font.custom(
                    AppFonts.FontName.manropeBold.rawValue,
                    size: AppFonts.Tokens.FontSize.headingXL
                )
            }
            
            public static var semiBold: SwiftUI.Font {
                SwiftUI.Font.custom(
                    AppFonts.FontName.manropeSemiBold.rawValue,
                    size: AppFonts.Tokens.FontSize.headingXL
                )
            }
            
            public static var medium: SwiftUI.Font {
                SwiftUI.Font.custom(
                    AppFonts.FontName.manropeMedium.rawValue,
                    size: AppFonts.Tokens.FontSize.headingXL
                )
            }
            
            public static var regular: SwiftUI.Font {
                SwiftUI.Font.custom(
                    AppFonts.FontName.manropeRegular.rawValue,
                    size: AppFonts.Tokens.FontSize.headingXL
                )
            }
        }
        
        // MARK: - HeadingMd (17px)
        /// font sizs 17px
        public enum HeadingMd {
            public static var bold: SwiftUI.Font {
                SwiftUI.Font.custom(
                    AppFonts.FontName.manropeBold.rawValue,
                    size: AppFonts.Tokens.FontSize.headingMd
                )
            }
            
            public static var semiBold: SwiftUI.Font {
                SwiftUI.Font.custom(
                    AppFonts.FontName.manropeSemiBold.rawValue,
                    size: AppFonts.Tokens.FontSize.headingMd
                )
            }
            
            public static var medium: SwiftUI.Font {
                SwiftUI.Font.custom(
                    AppFonts.FontName.manropeMedium.rawValue,
                    size: AppFonts.Tokens.FontSize.headingMd
                )
            }
            
            public static var regular: SwiftUI.Font {
                SwiftUI.Font.custom(
                    AppFonts.FontName.manropeRegular.rawValue,
                    size: AppFonts.Tokens.FontSize.headingMd
                )
            }
        }
        
        // MARK: - BodyTextMd (16px)
        /// font sizs 16px
        public enum BodyTextMd {
            public static var bold: SwiftUI.Font {
                SwiftUI.Font.custom(
                    AppFonts.FontName.manropeBold.rawValue,
                    size: AppFonts.Tokens.FontSize.bodyTextMd
                )
            }
            
            public static var semiBold: SwiftUI.Font {
                SwiftUI.Font.custom(
                    AppFonts.FontName.manropeSemiBold.rawValue,
                    size: AppFonts.Tokens.FontSize.bodyTextMd
                )
            }
            
            public static var medium: SwiftUI.Font {
                SwiftUI.Font.custom(
                    AppFonts.FontName.manropeMedium.rawValue,
                    size: AppFonts.Tokens.FontSize.bodyTextMd
                )
            }
            
            public static var regular: SwiftUI.Font {
                SwiftUI.Font.custom(
                    AppFonts.FontName.manropeRegular.rawValue,
                    size: AppFonts.Tokens.FontSize.bodyTextMd
                )
            }
        }
        
        // MARK: - BodyTextSm (15px)
        /// font sizs 15px
        public enum BodyTextSm {
            public static var bold: SwiftUI.Font {
                SwiftUI.Font.custom(
                    AppFonts.FontName.manropeBold.rawValue,
                    size: AppFonts.Tokens.FontSize.bodyTextSm
                )
            }
            
            public static var semiBold: SwiftUI.Font {
                SwiftUI.Font.custom(
                    AppFonts.FontName.manropeSemiBold.rawValue,
                    size: AppFonts.Tokens.FontSize.bodyTextSm
                )
            }
            
            public static var medium: SwiftUI.Font {
                SwiftUI.Font.custom(
                    AppFonts.FontName.manropeMedium.rawValue,
                    size: AppFonts.Tokens.FontSize.bodyTextSm
                )
            }
            
            public static var regular: SwiftUI.Font {
                SwiftUI.Font.custom(
                    AppFonts.FontName.manropeRegular.rawValue,
                    size: AppFonts.Tokens.FontSize.bodyTextSm
                )
            }
        }
        
        // MARK: - TextL (14px)
        /// font sizs 14px
        public enum TextL {
            public static var bold: SwiftUI.Font {
                SwiftUI.Font.custom(
                    AppFonts.FontName.manropeBold.rawValue,
                    size: AppFonts.Tokens.FontSize.textL
                )
            }
            
            public static var semiBold: SwiftUI.Font {
                SwiftUI.Font.custom(
                    AppFonts.FontName.manropeSemiBold.rawValue,
                    size: AppFonts.Tokens.FontSize.textL
                )
            }
            
            public static var medium: SwiftUI.Font {
                SwiftUI.Font.custom(
                    AppFonts.FontName.manropeMedium.rawValue,
                    size: AppFonts.Tokens.FontSize.textL
                )
            }
            
            public static var regular: SwiftUI.Font {
                SwiftUI.Font.custom(
                    AppFonts.FontName.manropeRegular.rawValue,
                    size: AppFonts.Tokens.FontSize.textL
                )
            }
        }
        
        // MARK: - TextMd (13px)
        /// font sizs 13px
        public enum TextMd {
            public static var bold: SwiftUI.Font {
                SwiftUI.Font.custom(
                    AppFonts.FontName.manropeBold.rawValue,
                    size: AppFonts.Tokens.FontSize.textMd
                )
            }
            
            public static var semiBold: SwiftUI.Font {
                SwiftUI.Font.custom(
                    AppFonts.FontName.manropeSemiBold.rawValue,
                    size: AppFonts.Tokens.FontSize.textMd
                )
            }
            
            public static var medium: SwiftUI.Font {
                SwiftUI.Font.custom(
                    AppFonts.FontName.manropeMedium.rawValue,
                    size: AppFonts.Tokens.FontSize.textMd
                )
            }
            
            public static var regular: SwiftUI.Font {
                SwiftUI.Font.custom(
                    AppFonts.FontName.manropeRegular.rawValue,
                    size: AppFonts.Tokens.FontSize.textMd
                )
            }
        }
        
        // MARK: - TextSm (12px)
        /// font sizs 12px
        public enum TextSm {
            public static var bold: SwiftUI.Font {
                SwiftUI.Font.custom(
                    AppFonts.FontName.manropeBold.rawValue,
                    size: AppFonts.Tokens.FontSize.textSm
                )
            }
            
            public static var semiBold: SwiftUI.Font {
                SwiftUI.Font.custom(
                    AppFonts.FontName.manropeSemiBold.rawValue,
                    size: AppFonts.Tokens.FontSize.textSm
                )
            }
            
            public static var medium: SwiftUI.Font {
                SwiftUI.Font.custom(
                    AppFonts.FontName.manropeMedium.rawValue,
                    size: AppFonts.Tokens.FontSize.textSm
                )
            }
            
            public static var regular: SwiftUI.Font {
                SwiftUI.Font.custom(
                    AppFonts.FontName.manropeRegular.rawValue,
                    size: AppFonts.Tokens.FontSize.textSm
                )
            }
        }
        
        // MARK: - CaptionMd (11px)
        /// font sizs 11px
        public enum CaptionMd {
            public static var medium: SwiftUI.Font {
                SwiftUI.Font.custom(
                    AppFonts.FontName.manropeMedium.rawValue,
                    size: AppFonts.Tokens.FontSize.captionMd
                )
            }
            
            public static var regular: SwiftUI.Font {
                SwiftUI.Font.custom(
                    AppFonts.FontName.manropeRegular.rawValue,
                    size: AppFonts.Tokens.FontSize.captionMd
                )
            }
        }
        
        // MARK: - CaptionSm (10px)
        /// font sizs 10px
        public enum CaptionSm {
            public static var medium: SwiftUI.Font {
                SwiftUI.Font.custom(
                    AppFonts.FontName.manropeMedium.rawValue,
                    size: AppFonts.Tokens.FontSize.captionSm
                )
            }
            
            public static var regular: SwiftUI.Font {
                SwiftUI.Font.custom(
                    AppFonts.FontName.manropeRegular.rawValue,
                    size: AppFonts.Tokens.FontSize.captionSm
                )
            }
        }
    }
}

public extension UIFont {
    static func appFont(_ name: AppFonts.FontName, size: CGFloat) -> UIFont {
        UIFont(name: name.rawValue, size: size)!
    }
}
