//
//  Extension+String.swift
//  AppCore
//
//  Created by Huseyn Hasanov on 24.11.25.
//

import Foundation

public extension String {
    
    var localized: String {
        let localizationManager: AppLocalizationProtocol = resolve()
        return localizationManager.localizedString(self)
    }
    
    func localized(with arguments: CVarArg...) -> String {
        return String(format: self.localized, arguments: arguments)
    }
}
