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
        userDefaults.set(false, forKey: .isAuthenticated)
        let isAuthenticated = userDefaults.bool(forKey: .isAuthenticated)
        
        if isAuthenticated {
            showTabBar()
        } else {
            showRegisterVC()
        }
    }
    
    func showRegisterVC() {
        let registerVC = dependencyContainer.resolve(
            AppAuthModule.self
        ).buildOnBoarding(self)
        let navigation = UINavigationController(rootViewController: registerVC)
        window.rootViewController = navigation
        window.makeKeyAndVisible()
    }
    
    func showTabBar() {
        let tabBarVC = AppTabBarBuilder(
            inputData: .init()
        ).build()
        window.rootViewController = tabBarVC
        UIView.transition(
            with: window,
            duration: 0.3,
            options: .transitionCrossDissolve,
            animations: nil
        )
        window.makeKeyAndVisible()
    }
}

extension AppCoordinator: AppAuthModuleDelegate {
    
    func appAuthModuleDidFinish() {
        showTabBar()
    }
}
