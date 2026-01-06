//
//  AppTextFieldModel.swift
//  AppCore
//
//  Created by Huseyn Hasanov on 06.01.26.
//

import UIKit

public extension AppTextField {
    
    struct Model {
        let title: String?
        let type: FieldType
        let keyboardType: UIKeyboardType
        
        public init(
            title: String? = nil,
            type: FieldType = .normal,
            keyboardType: UIKeyboardType = .default
        ) {
            self.type = type
            self.keyboardType = keyboardType
            self.title = title
        }
    }
    
    enum FieldType {
        case secure
        case normal
    }
}
