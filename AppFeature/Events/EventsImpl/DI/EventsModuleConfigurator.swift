// 
//  EventsModuleConfigurator.swift
//  Events
//
//  Created by Huseyn Hasanov on 17.01.26.
//

import Foundation
import DependecyInjection

public class EventsConfigurator {
    
    public init() {}

    public static func setup(
        diContainer: AppDIContainer
    ) {
        EventsDependencyContainer.setup(container: diContainer)
    }
}
