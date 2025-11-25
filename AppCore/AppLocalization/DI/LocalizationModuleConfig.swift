//
//  LocalizationModuleConfiguration.swift
//  AppCore
//
//  Created by Huseyn Hasanov on 24.11.25.
//

import DependecyInjection

public class LocalizationModuleConfig {
    
    public init() {}
    
    public func setup(
        diContainer: AppDIContainer
    ) {
        LocalizationDependencyContainer.setup(container: diContainer)
    }
}
