// 
//  DependencyContainer.swift
//  Clubs
//
//  Created by Huseyn Hasanov on 17.01.26.
//

import Clubs
import Foundation
import AppFoundation
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
        registrar.register(router: ClubsDeepLinkRouter())
    }
    
    private static func registerDataSource() {
        register(ClubsDataSource.self) {
            ClubsDataSourceImpl()
        }
    }
    
    private static func registerRepo() {
        register(ClubRepo.self) {
            ClubRepoImpl()
        }
    }
    
    private static func registerUseCase() {
        register(ClubsUseCase.self) {
            ClubsUseCaseImpl()
        }
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

