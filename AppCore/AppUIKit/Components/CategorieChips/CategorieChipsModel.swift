//
//  CategorieChipsModel.swift
//  AppCore
//
//  Created by Huseyn Hasanov on 30.12.25.
//

import Foundation
import SwiftUICore

public extension CategorieChipsView {
    
    struct Model: Identifiable, Hashable {
        public let id: UUID = UUID()
        public let title: String
        public let selected: Bool
        
        public init(title: String, selected: Bool) {
            self.title = title
            self.selected = selected
        }
        
        var backgroundColor: Color {
            selected ? Color.Palette.greenLight : Color.Palette.grayQuaternary
        }
        
        var borderColor: Color {
            selected ? Color.Palette.green900 : Color.Palette.grayTeritary
        }
    }
}
