//
//  AppDelegate+Localization.swift
//  App
//
//  Created by Huseyn Hasanov on 21.12.25.
//  Copyright © 2025 Bonjur. All rights reserved.
//

import AppLocalization
import DependecyInjection
import Foundation
import AppAuthImpl

extension AppDelegate {
    
    func setupLocalization(container: AppDIContainer) {
        let localization = container.resolve(AppLocalizationProtocol.self)
        localization.registerBundle(
            Bundle.main,
            Bundle(for: AuthModuleConfigurator.self),
        )
     }
}
