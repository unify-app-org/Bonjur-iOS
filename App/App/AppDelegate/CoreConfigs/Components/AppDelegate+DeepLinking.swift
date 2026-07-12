//
//  AppDelegate+DeepLinking.swift
//  App
//
//  Created by Huseyn Hasanov on 10.07.26.
//  Copyright © 2026 Unify. All rights reserved.
//

import AppFoundation
import DependecyInjection

extension AppDelegate {

    /// One shared `DeepLinkManager` behind both protocols: feature modules
    /// resolve `DeepLinkRegistrar` to add their routers during setup, callers
    /// resolve `DeepLinkManagerProtocol` to dispatch. Must run before
    /// `setUpFeature` so the registrar exists when modules register.
    func setUpDeepLinking(_ container: AppDIContainer) {
        let manager = DeepLinkManager()

        container.register(DeepLinkManagerProtocol.self, isSingleton: true) {
            manager
        }
        container.register(DeepLinkRegistrar.self, isSingleton: true) {
            manager
        }
    }
}
