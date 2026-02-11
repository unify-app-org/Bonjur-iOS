// 
//  DependencyContainer.swift
//  Hangouts
//
//  Created by Huseyn Hasanov on 17.01.26.
//

import Foundation
import Hangouts
import DependecyInjection

func resolve<T>(
    _ type: T.Type = T.self
) -> T {
    HangoutsDependencyContainer.resolve(type)
}

func register<T>(
    _ type: T.Type = T.self,
    isSingleton: Bool = false,
    _ factory: @escaping () -> T
) {
    HangoutsDependencyContainer.register(
        type,
        isSingleton: isSingleton,
        factory
    )
}

enum HangoutsDependencyContainer {
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
        register(HangoutsDataSource.self) {
            HangoutsDataSourceImpl()
        }
    }
    
    private static func registerUseCase() {
        register(HangoutsUseCase.self) {
            HangoutsUseCaseImpl()
        }
    }
    
    private static func registerModule() {
        register(HangoutsModule.self) {
            HangoutsModuleImpl()
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

