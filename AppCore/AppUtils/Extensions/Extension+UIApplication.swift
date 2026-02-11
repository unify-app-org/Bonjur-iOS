//
//  Extension+UIApplication.swift
//  AppCore
//
//  Created by Huseyn Hasanov on 28.12.25.
//

import UIKit

public extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder),
                   to: nil, from: nil, for: nil)
    }
}
