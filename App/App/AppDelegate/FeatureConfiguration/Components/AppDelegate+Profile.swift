//
//  AppDelegate+Profile.swift
//  App
//
//  Created by Huseyn Hasanov on 04.02.26.
//  Copyright © 2026 Unify community group. All rights reserved.
//

import DependecyInjection
import ProfileImpl
import Profile
import UIKit
import AppNetwork
import AppStorage
import AppWidgetShared
import WidgetKit

extension AppDelegate {
    func setUpProfile(_ container: AppDIContainer) {
        container.register(ProfileDelegate.self) {
            ProfileDelegateImpl(
                tokenManger: container.resolve(TokenManager.self),
                userDefaults: container.resolve(UserDefaultsProtocol.self)
            )
        }
        ProfileConfigurator.setup(diContainer: container)
    }
}

class ProfileDelegateImpl: ProfileDelegate {
    private let tokenManger: TokenManager
    private let userDefaults: UserDefaultsProtocol

    init(
        tokenManger: TokenManager,
        userDefaults: UserDefaultsProtocol
    ) {
        self.tokenManger = tokenManger
        self.userDefaults = userDefaults
    }

    func logout() {
        Task {
            userDefaults.set(false, forKey: .isAuthenticated)
            UserCardWidgetStore.clear()
            WidgetCenter.shared.reloadTimelines(ofKind: UserCardWidgetStore.widgetKind)
            await tokenManger.clearTokens()
            await showRegister()
        }
    }

    @MainActor
    private func showRegister() {
        guard let sceneDelegate = currentSceneDelegate(),
              let window = sceneDelegate.window else {
            return
        }
        
        if sceneDelegate.appCoordinator == nil {
            sceneDelegate.appCoordinator = AppCoordinator(window: window)
        }
        sceneDelegate.appCoordinator?.showRegisterVC()
    }

    @MainActor
    private func currentSceneDelegate() -> SceneDelegate? {
        guard let scene = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first(where: { $0.activationState == .foregroundActive }) else {
            return nil
        }

        return scene.delegate as? SceneDelegate
    }
}
