//
//  AppCoordinator.swift
//  App
//
//  Created by Huseyn Hasanov on 25.11.25.
//

import UIKit
import AppAuth
import DependecyInjection
import AppStorage

final class AppCoordinator {
    private let window: UIWindow
    private let dependencyContainer: AppDIContainer
    private var userDefaults: UserDefaultsProtocol

    init(
        window: UIWindow,
        dependencyContainer: AppDIContainer = .shared
    ) {
        self.window = window
        self.dependencyContainer = dependencyContainer
        self.userDefaults = dependencyContainer.resolve(UserDefaultsProtocol.self)
    }
    
    func start() {
        let registerVc = dependencyContainer.resolve(
            AppAuthEntryModule.self
        ).buildRegister()
        let navigation = UINavigationController(rootViewController: registerVc)
        window.rootViewController = navigation
        window.makeKeyAndVisible()
    }
}
