//
//  AppButtonModel.swift
//  AppCore
//
//  Created by Huseyn Hasanov on 23.12.25.
//

import Foundation
import SwiftUI

public extension AppButton {
    
    struct Model {
        let type: ButtonType
        let style: ButtonStyle
        let contentSize: ContentSize
        
        public init(
            type: ButtonType = .primary,
            style: ButtonStyle = .default,
            contentSize: ContentSize = .fit
        ) {
            self.type = type
            self.style = style
            self.contentSize = contentSize
        }
        
        var backgroundColor: Color {
            switch type {
            case .primary:
                if style == .default {
                    return .Palette.primary
                } else {
                    return .Palette.secondary
                }
            case .secondary:
                if style == .default {
                    return .clear
                } else {
                    return .Palette.primary.opacity(0.2)
                }
            case .tertiary:
                if style == .default {
                    return .clear
                } else {
                    return .Palette.black.opacity(0.05)
                }
            }
        }
        
        var horizontalPadding: CGFloat {
            return 23
        }
        
        var verticalPadding: CGFloat {
            return 16
        }
        
        var edges: EdgeInsets {
            EdgeInsets(
                top: verticalPadding,
                leading: horizontalPadding,
                bottom: verticalPadding,
                trailing: horizontalPadding
            )
        }
        
        var textFont: SwiftUICore.Font {
            return Font.Typography.BodyTextMd.medium
        }
        
        var foregroundColor: Color {
            return Color.Palette.black
        }
        
        var borderColor: Color {
            if style == .default {
                return Color.Palette.blackHigh
            } else {
                return Color.Palette.border
            }
        }
        
        var borderWidth: CGFloat {
            switch type {
            case .secondary:
                return 0.5
            default:
                return 0
            }
        }
    }
    
    enum ContentSize {
        case fill
        case fit
    }
    
    enum ButtonType {
        case primary
        case secondary
        case tertiary
    }
    
    enum ButtonStyle {
        case `default`
        case hover
    }
}
