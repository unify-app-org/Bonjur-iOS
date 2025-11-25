//
//  NetworkModuleConfig.swift
//  AppCore
//
//  Created by Huseyn Hasanov on 24.11.25.
//

import DependecyInjection

public class NetworkModuleConfig {
    
    public init() {}
    
    public func setup(
        diContainer: AppDIContainer
    ) {
        NetworkDependencyContainer.setup(container: diContainer)
    }
}
