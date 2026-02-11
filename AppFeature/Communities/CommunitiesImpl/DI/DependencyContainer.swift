// 
//  DependencyContainer.swift
//  Communities
//
//  Created by Huseyn Hasanov on 17.01.26.
//

import Foundation
import Communities
import DependecyInjection

func resolve<T>(
    _ type: T.Type = T.self
) -> T {
    CommunitiesDependencyContainer.resolve(type)
}

func register<T>(
    _ type: T.Type = T.self,
    isSingleton: Bool = false,
    _ factory: @escaping () -> T
) {
    CommunitiesDependencyContainer.register(
        type,
        isSingleton: isSingleton,
        factory
    )
}

enum CommunitiesDependencyContainer {
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
        register(CommunityDataSource.self) {
            CommunityDataSourceImpl()
        }
    }
    
    private static func registerUseCase() {
        register(CommunityUseCase.self) {
            CommunityUseCaseImpl()
        }
    }
    
    private static func registerModule() {
        register(CommunitiesModule.self) {
            CommunitiesModuleImpl()
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

