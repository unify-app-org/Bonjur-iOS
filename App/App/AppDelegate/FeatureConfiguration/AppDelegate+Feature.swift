//
//  AppDelegate+Feature.swift
//  App
//
//  Created by Huseyn Hasanov on 24.11.25.
//

import DependecyInjection

extension AppDelegate {
    func setUpFeature(container: AppDIContainer) {
        setUpAuth(container)
    } 
}
