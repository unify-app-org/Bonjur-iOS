//
//  SceneDelegate.swift
//  App
//
//  Created by Huseyn Hasanov on 24.11.25.
//

import UIKit
import AppAuthImpl
import AppFoundation
import DependecyInjection

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        self.window = window

        appCoordinator = AppCoordinator(window: window)
        appCoordinator?.start()
    }

    func scene(
        _ scene: UIScene,
        openURLContexts URLContexts: Set<UIOpenURLContext>
    ) {
        guard let urlContext = URLContexts.first else { return }
        MicrosoftAuthCallback.handle(
            urlContext.url,
            sourceApplication: urlContext.options.sourceApplication
        )
        handleDeepLink(url: urlContext.url)
    }

    /// Custom-scheme deep links (e.g. `bonjur://club?id=12`). Identifiers come
    /// from whatever module routers registered at launch; unknown links no-op.
    private func handleDeepLink(url: URL) {
        let manager = AppDIContainer.shared.resolve(DeepLinkManagerProtocol.self)
        let parser = DeepLinkDataParser(deepLinksIdentifiers: manager.deepLinksIdentifiers())

        guard let notification = parser.parseDeepLinkData(from: url) else { return }
        manager.process(notification: notification, context: .default)
    }
}
