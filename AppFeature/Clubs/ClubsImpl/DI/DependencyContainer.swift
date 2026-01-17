// 
//  DependencyContainer.swift
//  Clubs
//
//  Created by Huseyn Hasanov on 17.01.26.
//

import Clubs
import Foundation
import DependecyInjection

func resolve<T>(
    _ type: T.Type = T.self
) -> T {
    ClubsDependencyContainer.resolve(type)
}

func register<T>(
    _ type: T.Type = T.self,
    isSingleton: Bool = false,
    _ factory: @escaping () -> T
) {
    ClubsDependencyContainer.register(
        type,
        isSingleton: isSingleton,
        factory
    )
}

enum ClubsDependencyContainer {
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

    }
    
    private static func registerUseCase() {

    }
    
    private static func registerModule() {
        register(ClubsModule.self) {
            ClubsModuleImpl()
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

