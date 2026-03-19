//
//  AuthDependencyContainer.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 24.11.25.
//


import Foundation
import DependecyInjection
import AppAuth

func resolve<T>(
    _ type: T.Type = T.self
) -> T {
    AuthDependencyContainer.resolve(type)
}

func register<T>(
    _ type: T.Type = T.self,
    isSingleton: Bool = false,
    _ factory: @escaping () -> T
) {
    AuthDependencyContainer.register(
        type,
        isSingleton: isSingleton,
        factory
    )
}

enum AuthDependencyContainer {
    private static var container = AppDIContainer()
    
    // MARK: - Setup
    
    static func setup(container: AppDIContainer? = nil) {
        if let inputContainer = container {
            self.container = inputContainer
        }
        
        registerModule()
        registerHelpers()
        registerDataSource()
        registerRepo()
        registerUseCase()
    }
    
    // MARK: - Dependencies Registration
    
    private static func registerHelpers() {
        
    }
    
    private static func registerDataSource() {
        register { AuthDataSourceImpl() as AuthDataSource }
    }
    
    private static func registerRepo() {
        register { AuthRepoImpl() as AuthRepo }
    }
    
    private static func registerUseCase() {
        register { AuthUsecasesImpl() as AuthUsecases }
    }
    
    private static func registerModule() {
        register(AppAuthEntryModuleImpl.self, isSingleton: true) {
            AppAuthEntryModuleImpl()
        }
        
        register(AppAuthModule.self, isSingleton: true) {
            resolve(AppAuthEntryModuleImpl.self)
        }
        
        register(AuthDelegate.self, isSingleton: true) {
            resolve(AppAuthEntryModuleImpl.self)
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

