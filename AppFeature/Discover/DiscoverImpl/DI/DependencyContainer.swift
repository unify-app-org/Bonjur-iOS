// 
//  DependencyContainer.swift
//  Discover
//
//  Created by Huseyn Hasanov on 11.01.26.
//

import Foundation
import DependecyInjection
import Discover

func resolve<T>(
    _ type: T.Type = T.self
) -> T {
    DiscoverDependencyContainer.resolve(type)
}

func register<T>(
    _ type: T.Type = T.self,
    isSingleton: Bool = false,
    _ factory: @escaping () -> T
) {
    DiscoverDependencyContainer.register(
        type,
        isSingleton: isSingleton,
        factory
    )
}

enum DiscoverDependencyContainer {
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
        register(DiscoverDataSource.self) {
            DiscoverDataSourceImpl()
        }
    }
    
    private static func registerUseCase() {
        register(DiscoverUseCase.self) {
            DiscoverUseCaseImpl()
        }
    }
    
    private static func registerModule() {
        register(DiscoverModuleImpl.self, isSingleton: true) {
            DiscoverModuleImpl()
        }
        
        register(DiscoverModule.self, isSingleton: true) {
            resolve(DiscoverModuleImpl.self)
        }
        
        register(DiscoverDeleagete.self, isSingleton: true) {
            resolve(DiscoverModuleImpl.self)
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

