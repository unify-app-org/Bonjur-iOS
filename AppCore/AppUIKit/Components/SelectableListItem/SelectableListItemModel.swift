//
//  SelectableListItemModel.swift
//  AppCore
//
//  Created by Huseyn Hasanov on 26.12.25.
//

import SwiftUI

public extension SelectableListItemView {
    
    struct Model: Identifiable {
        public let id: UUID = UUID()
        public let title: String
        public var selected: Bool
        public let style: Style
        
        public init(
            title: String,
            selected: Bool,
            style: Style = .default
        ) {
            self.title = title
            self.selected = selected
            self.style = style
        }
        
        public enum Style {
            case `default`
            case multySelect
        }
        
        var backgroundColor: Color {
            if selected {
                return Color.Palette.primary
            } else {
                return .clear
            }
        }
        
        var borderColor: Color {
            return Color.Palette.graySecondary
        }
        
        var borderWidth: CGFloat {
            return 0.5
        }
        
    }
}
