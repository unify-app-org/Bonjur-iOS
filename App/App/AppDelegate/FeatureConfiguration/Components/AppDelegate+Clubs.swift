//
//  AppDelegate+Clubs.swift
//  App
//
//  Created by Huseyn Hasanov on 17.01.26.
//  Copyright © 2026 Unify. All rights reserved.
//

import DependecyInjection
import ClubsImpl

extension AppDelegate {
    func setUpClubs(_ container: AppDIContainer) {
        ClubsConfigurator.setup(diContainer: container)
    }
}
