// 
//  DependencyContainer.swift
//  Notification
//
//  Created by Huseyn Hasanov on 27.06.26.
//

import Foundation
import DependecyInjection
import Notification

func resolve<T>(
    _ type: T.Type = T.self
) -> T {
    NotificationDependencyContainer.resolve(type)
}

func register<T>(
    _ type: T.Type = T.self,
    isSingleton: Bool = false,
    _ factory: @escaping () -> T
) {
    NotificationDependencyContainer.register(
        type,
        isSingleton: isSingleton,
        factory
    )
}

enum NotificationDependencyContainer {
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
        register(NotificationDataSource.self) {
            NotificationNetworkDataSource()
        }

        register(JoinRequestDataSource.self) {
            JoinRequestDataSourceImpl()
        }
    }

    private static func registerUseCase() {
        register(NotificationUseCase.self) {
            NotificationUseCaseImpl()
        }

        register(NeedsActionUseCase.self) {
            NeedsActionUseCaseImpl()
        }

        register(VerificationUseCase.self) {
            VerificationUseCaseImpl()
        }
    }

    private static func registerModule() {
        register(NotificationModuleImpl.self, isSingleton: true) {
            NotificationModuleImpl()
        }

        register(NotificationModule.self, isSingleton: true) {
            resolve(NotificationModuleImpl.self)
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

