//
//  AuthModuleConfigurator.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 24.11.25.
//

import DependecyInjection

public class AuthModuleConfigurator {
    
    public init() {}
    
    public static func setup(
        diContainer: AppDIContainer
    ) {
        AuthDependencyContainer.setup(container: diContainer)
    }
}
