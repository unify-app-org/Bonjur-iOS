// 
//  DependencyContainer.swift
//  Profile
//
//  Created by Huseyn Hasanov on 04.02.26.
//

import Foundation
import Profile
import AppFoundation
import DependecyInjection

func resolve<T>(
    _ type: T.Type = T.self
) -> T {
    ProfileDependencyContainer.resolve(type)
}

func register<T>(
    _ type: T.Type = T.self,
    isSingleton: Bool = false,
    _ factory: @escaping () -> T
) {
    ProfileDependencyContainer.register(
        type,
        isSingleton: isSingleton,
        factory
    )
}

enum ProfileDependencyContainer {
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
        registerDeepLinks()
    }

    // MARK: - Dependencies Registration

    private static func registerHelpers() {

    }

    /// Registers this module's deep-link routes with the app-wide registrar
    /// (registered in the shared container before feature setup runs).
    private static func registerDeepLinks() {
        let registrar = resolve(DeepLinkRegistrar.self)
        registrar.register(router: ProfileDeepLinkRouter())
    }
    
    private static func registerDataSource() {
        register(ProfileDataSource.self) {
            ProfileDataSourceImpl()
        }
    }
    
    private static func registerUseCase() {
        register(ProfileUseCase.self) {
            ProfileUseCaseImpl()
        }
    }
    
    private static func registerRepo() {
        register(ProfileRepo.self) {
            ProfileRepoImpl()
        }
    }
    
    private static func registerModule() {
        register(ProfileModule.self) {
            ProfileModuleImpl()
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

