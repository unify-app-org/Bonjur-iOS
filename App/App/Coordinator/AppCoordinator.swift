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
import AppWidgetShared
import WidgetKit
import Profile

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
        let isAuthenticated = userDefaults.bool(forKey: .isAuthenticated)
        // Re-mirror every launch: sessions that signed in before the flag existed have
        // no value in the group, and a forced 401 logout clears the app flag only.
        UserCardWidgetStore.setSignedIn(isAuthenticated)
        if !isAuthenticated { UserCardWidgetStore.clear() }
        WidgetCenter.shared.reloadTimelines(ofKind: UserCardWidgetStore.widgetKind)
        
        var apiClient: APIClientProtocol = dependencyContainer.resolve(
            APIClientProtocol.self
        )
        apiClient.activityDelegate = self
        
        Task { @MainActor in
            if isAuthenticated {
                // The widget's card is normally written when the user opens their own
                // profile. A widget added right after signing in would otherwise sit
                // empty until they happen to visit that tab.
                dependencyContainer.resolve(ProfileModule.self).publishWidgetCardIfNeeded()
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
    private func showTabBar() {
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
