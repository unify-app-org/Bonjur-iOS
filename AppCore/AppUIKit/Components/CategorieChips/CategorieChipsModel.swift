//
//  CategorieChipsModel.swift
//  AppCore
//
//  Created by Huseyn Hasanov on 30.12.25.
//

import Foundation
import SwiftUI

public extension CategoriesChipsView {
    
    struct Model: Identifiable, Hashable {
        public let uuid: UUID = UUID()
        public let id: Int
        public let title: String
        public var selected: Bool
        
        public init(
            id: Int,
            title: String,
            selected: Bool
        ) {
            self.id = id
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
