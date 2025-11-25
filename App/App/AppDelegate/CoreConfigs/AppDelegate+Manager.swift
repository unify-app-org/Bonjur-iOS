//
//  AppDelegate+Manager.swift
//  App
//
//  Created by Huseyn Hasanov on 24.11.25.
//

import AppFoundation
import AppNetwork
import AppStorage

extension AppDelegate {
    func setUpManagers(_ container: AppDIContainer) {
        LocalizationModuleConfig().setup(diContainer: container)
        
        StorageModuleConfig().setUp(container: container)
        
        NetworkModuleConfig().setup(diContainer: container)
    }
}
