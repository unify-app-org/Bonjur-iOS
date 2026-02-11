// 
//  DependencyContainer.swift
//  Groups
//
//  Created by Huseyn Hasanov on 23.01.26.
//

import Foundation
import DependecyInjection
import Groups

func resolve<T>(
    _ type: T.Type = T.self
) -> T {
    GroupsDependencyContainer.resolve(type)
}

func register<T>(
    _ type: T.Type = T.self,
    isSingleton: Bool = false,
    _ factory: @escaping () -> T
) {
    GroupsDependencyContainer.register(
        type,
        isSingleton: isSingleton,
        factory
    )
}

enum GroupsDependencyContainer {
    private static var container = AppDIContainer()
    
    // MARK: - Setup
    
    static func setup(container: AppDIContainer? = nil) {
        if let inputContainer = container {
            self.container = inputContainer
        }
        
        registerModule()
        registerHelpers()
        registerDataSource()
        registerUseCase()
    }
    
    // MARK: - Dependencies Registration
    
    private static func registerHelpers() {
        
    }
    
    private static func registerDataSource() {
        register(GroupsDataSource.self) {
            GroupsDataSourceImpl()
        }
    }
    
    private static func registerUseCase() {
        register(GroupsUseCase.self) {
            GroupsUseCaseImpl()
        }
    }
    
    private static func registerModule() {
        register(GroupsModule.self) {
            GroupsModuleImpl()
        }
    }
    
    // MARK: - Dependencies Managing
    
    fileprivate static func register<T>(
        _ type: T.Type = T.self,
        isSingleton: Bool = false,
        _ factory: @escaping () -> T
    ) {
        container.register(
            type,
            isSingleton: isSingleton,
            factory
        )
    }
    
    fileprivate static func resolve<T>(_ type: T.Type) -> T {
        let service = container.resolve(type)
        return service
    }
}

