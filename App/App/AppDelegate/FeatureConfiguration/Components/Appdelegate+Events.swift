//
//  Appdelegate+Evenets.swift
//  App
//
//  Created by Huseyn Hasanov on 17.01.26.
//  Copyright © 2026 Unify. All rights reserved.
//

import DependecyInjection
import EventsImpl

extension AppDelegate {
    func setUpEvents(_ container: AppDIContainer) {
        EventsConfigurator.setup(diContainer: container)
    }
}
