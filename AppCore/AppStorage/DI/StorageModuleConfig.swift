//
//  StorageModuleConfig.swift
//  AppCore
//
//  Created by Huseyn Hasanov on 24.11.25.
//

import DependecyInjection

public final class StorageModuleConfig {
    
    public init() {}
    
    public func setUp(
        container: AppDIContainer
    ) {
        StorageDependencyContainer.setup(container: container)
    }
}
