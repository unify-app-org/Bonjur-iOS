//
//  AppDelegate+Groups.swift
//  App
//
//  Created by Huseyn Hasanov on 23.01.26.
//  Copyright © 2026 Unify. All rights reserved.
//

import DependecyInjection
import GroupsImpl

extension AppDelegate {
    func setUpGroups(_ container: AppDIContainer) {
        GroupsConfigurator.setup(diContainer: container)
    }
}
