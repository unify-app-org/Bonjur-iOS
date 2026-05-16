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
import AppNetwork
import AppUIKit

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
//        userDefaults.set(false, forKey: .isAuthenticated)
        userDefaults.set(1, forKey: .communityId)
        let isAuthenticated = userDefaults.bool(forKey: .isAuthenticated)
        
        var apiClient: APIClientProtocol = dependencyContainer.resolve(
            APIClientProtocol.self
        )
        apiClient.activityDelegate = self
        
        Task { @MainActor in
            if isAuthenticated {
                showTabBar()
            } else {
                showRegisterVC()
            }
        }
    }
    
    @MainActor
    func showRegisterVC() {
        let registerVC = dependencyContainer.resolve(
            AppAuthModule.self
        ).buildOnBoarding(self)
        let navigation = UINavigationController(rootViewController: registerVC)
        window.rootViewController = navigation
        window.makeKeyAndVisible()
    }
    
    @MainActor
    func showTabBar() {
        let tabBarVC = AppTabBarBuilder(
            inputData: .init(),
            dependencyContainer: dependencyContainer
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

extension AppCoordinator: NetworkActivityDelegate {
    
    func refreshDidStart() {
        AppLoadingUI.show()
    }
    
    func refreshDidFinish() {
        AppLoadingUI.dismiss()
    }
    
    func refreshFailure() {
        Task { @MainActor in
            showRegisterVC()
        }
    }
}

extension AppCoordinator: AppAuthModuleDelegate {
    
    func appAuthModuleDidFinish() {
        Task { @MainActor in
            showTabBar()
        }
    }
}
