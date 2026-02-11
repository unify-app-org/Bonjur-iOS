//
//  Appdelegate+Hangouts.swift
//  App
//
//  Created by Huseyn Hasanov on 17.01.26.
//  Copyright © 2026 Unify. All rights reserved.
//

import DependecyInjection
import HangoutsImpl

extension AppDelegate {
    func setUpHangouts(_ container: AppDIContainer) {
        HangoutsConfigurator.setup(diContainer: container)
    }
}
