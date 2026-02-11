//
//  AppDelegate+Profile.swift
//  App
//
//  Created by Huseyn Hasanov on 04.02.26.
//  Copyright © 2026 Unify community group. All rights reserved.
//

import DependecyInjection
import ProfileImpl

extension AppDelegate {
    func setUpProfile(_ container: AppDIContainer) {
        ProfileConfigurator.setup(diContainer: container)
    }
}
