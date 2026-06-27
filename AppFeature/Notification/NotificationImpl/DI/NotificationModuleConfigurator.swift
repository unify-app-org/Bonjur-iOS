// 
//  NotificationModuleConfigurator.swift
//  Notification
//
//  Created by Huseyn Hasanov on 27.06.26.
//

import Foundation
import DependecyInjection

public class NotificationConfigurator {
    
    public init() {}

    public static func setup(
        diContainer: AppDIContainer
    ) {
        NotificationDependencyContainer.setup(container: diContainer)
    }
}
