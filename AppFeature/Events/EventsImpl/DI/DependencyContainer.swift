// 
//  DependencyContainer.swift
//  Events
//
//  Created by Huseyn Hasanov on 17.01.26.
//

import Foundation
import DependecyInjection
import Events

func resolve<T>(
    _ type: T.Type = T.self
) -> T {
    EventsDependencyContainer.resolve(type)
}

func register<T>(
    _ type: T.Type = T.self,
    isSingleton: Bool = false,
    _ factory: @escaping () -> T
) {
    EventsDependencyContainer.register(
        type,
        isSingleton: isSingleton,
        factory
    )
}

enum EventsDependencyContainer {
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
        print("test")
    }
    
    private static func registerDataSource() {
        register(EventsDataSource.self) {
            EventsDataSourceImpl()
        }
    }
    
    private static func registerUseCase() {
        register(EventsUseCase.self) {
            EventsUseCaseImpl()
        }
    }
    
    private static func registerModule() {
        register(EventsModule.self) {
            EventsModuleImpl()
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

