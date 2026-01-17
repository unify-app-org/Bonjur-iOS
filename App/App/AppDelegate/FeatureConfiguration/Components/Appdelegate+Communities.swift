//
//  Appdelegate+Communities.swift
//  App
//
//  Created by Huseyn Hasanov on 17.01.26.
//  Copyright © 2026 Bonjur. All rights reserved.
//

import DependecyInjection
import CommunitiesImpl

extension AppDelegate {
    func setUpCommunities(_ container: AppDIContainer) {
        CommunitiesConfigurator.setup(diContainer: container)
    }
}
