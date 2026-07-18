//
//  AppEmptyModel.swift
//  AppCore
//
//  Created by Huseyn Hasanov on 20.01.26.
//

import UIKit

public extension AppEmptyView {
    
    struct Model {
        let icon: UIImage?
        let text: String
        /// `nil` hides the action button, for empty states with no destination
        /// to send the user to.
        let buttonTitle: String?

        public init(
            icon: UIImage?,
            text: String,
            buttonTitle: String? = nil
        ) {
            self.icon = icon
            self.text = text
            self.buttonTitle = buttonTitle
        }
    }
}
