//
//  AppDelegate+Notification.swift
//  App
//
//  Created by Huseyn Hasanov on 28.06.26.
//  Copyright © 2026 Unify. All rights reserved.
//

import DependecyInjection
import NotificationImpl

extension AppDelegate {
    func setUpNotification(_ container: AppDIContainer) {
        NotificationConfigurator.setup(diContainer: container)
    }
}
