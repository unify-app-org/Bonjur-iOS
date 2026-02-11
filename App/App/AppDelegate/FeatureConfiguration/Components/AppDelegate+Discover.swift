//
//  AppDelegate+Discover.swift
//  App
//
//  Created by Huseyn Hasanov on 11.01.26.
//  Copyright © 2026 Unify. All rights reserved.
//

import DependecyInjection
import DiscoverImpl

extension AppDelegate {
    func setUpDiscovery(_ container: AppDIContainer) {
        DiscoverConfigurator.setup(diContainer: container)
    }
}
