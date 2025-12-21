//
//  AppDelegate.swift
//  App
//
//  Created by Huseyn Hasanov on 24.11.25.
//

import UIKit
import DependecyInjection
import AppUIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    private let dependencyContainer = AppDIContainer.shared
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        setUpCore(container: dependencyContainer)
        setupLocalization(container: dependencyContainer)
        setupTypography()
        setUpFeature(container: dependencyContainer)
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        if connectingSceneSession.role == UISceneSession.Role.windowApplication {
            let config = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
            config.delegateClass = SceneDelegate.self
            return config
        }
        fatalError("No scene configuration found")
    }
    
    func application(
        _ application: UIApplication,
        didDiscardSceneSessions sceneSessions: Set<UISceneSession>
    ) {
        
    }
}

extension AppDelegate {
    
    private func setupTypography() {
        let _ = AppFonts()
     }
}
