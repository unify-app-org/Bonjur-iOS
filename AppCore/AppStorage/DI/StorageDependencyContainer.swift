//
//  StorageDependencyContainer.swift
//  AppCore
//
//  Created by Huseyn Hasanov on 24.11.25.
//


import Foundation
import DependecyInjection

func resolve<T>(_ type: T.Type = T.self) -> T {
    StorageDependencyContainer.resolve(type)
}

func register<T>(
    _ type: T.Type = T.self,
    isSingleton: Bool = false,
    _ factory: @escaping () -> T
) {
    StorageDependencyContainer.register(
        type,
        isSingleton: isSingleton,
        factory
    )
}

enum StorageDependencyContainer {
    private static var container = AppDIContainer()
    
    // MARK: - Setup
    
    static func setup(container: AppDIContainer? = nil) {
        if let inputContainer = container {
            self.container = inputContainer
        }
        registerHelpers()
    }
    
    // MARK: - Dependencies Registration
    
    private static func registerHelpers() {
        register(isSingleton: true) { UserDefaultsImpl() as UserDefaultsProtocol }
        register(isSingleton: true) { KeychainImpl() as KeychainProtocol }
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
