//
//  LocalizationDependencyContainer.swift
//  AppCore
//
//  Created by Huseyn Hasanov on 24.11.25.
//


import Foundation
import DependecyInjection

func resolve<T>(_ type: T.Type = T.self) -> T {
    LocalizationDependencyContainer.resolve(type)
}

func register<T>(
    _ type: T.Type = T.self,
    isSingleton: Bool = false,
    _ factory: @escaping () -> T
) {
    LocalizationDependencyContainer.register(
        type,
        isSingleton: isSingleton,
        factory
    )
}

enum LocalizationDependencyContainer {
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
        register(isSingleton: true) { AppLocalizationImpl() as AppLocalizationProtocol }
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
