//
//  DeepLinkRouter+ViewHierarchy.swift
//  AppFoundation
//
//  Created by Huseyn Hasanov on 10.07.26.
//

import UIKit

/// Shared navigation plumbing for module routers: resolve the host view
/// controller from the context and push onto whatever navigation stack is on
/// top. (No tab-bar paging here — Bonjur's floating dock keeps every tab on
/// one root navigation stack; pushing on top is enough.)
public extension DeepLinkRouter {

    /// The host to navigate from, honoring the context override.
    func hostViewController(for context: DeepLinkContext) -> UIViewController {
        switch context.navigationType {
        case .default:
            return topViewController()
        case .overCurrentContext(let topViewController):
            return topViewController ?? self.topViewController()
        }
    }

    /// Pushes `viewController` on the host's navigation controller; falls back
    /// to a modal presentation when there is no navigation stack.
    func show(
        _ viewController: UIViewController,
        with context: DeepLinkContext
    ) {
        let host = hostViewController(for: context)
        if let navigationController = host as? UINavigationController
            ?? host.navigationController {
            navigationController.pushViewController(viewController, animated: context.animated)
        } else {
            let navigationController = UINavigationController(rootViewController: viewController)
            host.present(navigationController, animated: context.animated)
        }
    }

    /// Topmost visible view controller of the key window.
    func topViewController() -> UIViewController {
        let window = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap(\.windows)
            .first(where: \.isKeyWindow)

        var top = window?.rootViewController ?? UIViewController()
        while true {
            if let presented = top.presentedViewController {
                top = presented
            } else if let navigation = top as? UINavigationController,
                      let visible = navigation.visibleViewController {
                top = visible
            } else if let tab = top as? UITabBarController,
                      let selected = tab.selectedViewController {
                top = selected
            } else {
                break
            }
        }
        return top
    }
}
