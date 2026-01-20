//
//  AppEmptyModel.swift
//  AppCore
//
//  Created by Huseyn Hasanov on 20.01.26.
//

import UIKit

public extension AppEmptyView {
    
    struct Model {
        let icon: UIImage
        let text: String
        let buttonTitle: String
        
        public init(
            icon: UIImage,
            text: String,
            buttonTitle: String
        ) {
            self.icon = icon
            self.text = text
            self.buttonTitle = buttonTitle
        }
    }
}
