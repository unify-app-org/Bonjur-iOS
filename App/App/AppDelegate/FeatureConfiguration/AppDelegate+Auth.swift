//
//  AppDelegate+Feature.swift
//  App
//
//  Created by Huseyn Hasanov on 24.11.25.
//

import DependecyInjection
import AppAuthImpl

extension AppDelegate {
    func setUpAuth(_ container: AppDIContainer) {
        AuthModuleConfigurator().setup(diContainer: container)
    }
}
