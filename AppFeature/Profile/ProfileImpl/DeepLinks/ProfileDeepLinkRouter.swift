//
//  ProfileDeepLinkRouter.swift
//  ProfileImpl
//
//  Created by Huseyn Hasanov on 10.07.26.
//

import UIKit
import Profile
import AppFoundation

/// Deep links into the Profile module. Registered with the shared
/// `DeepLinkRegistrar` during module DI setup.
/// Matches notification `targetType: USER` (identifier "user", payload `id`);
/// the notification `type` arrives as the `action` and picks the screen.
final class ProfileDeepLinkRouter: DeepLinkRouter {
    /// Notification-service `type` values that target a user.
    private enum Action: String {
        /// Friend's birthday — land on their profile to wish them.
        case birthday = "BIRTHDAY"
    }

    private enum PayloadKey: String {
        case id
    }

    let deepLinkIdentifier = "user"
    let isAuthenticationRequired = true

    func canProcess(notification: DeepLinkNotification) -> Bool {
        notification.identifier == deepLinkIdentifier
            && userId(from: notification) != nil
    }

    func process(notification: DeepLinkNotification, context: DeepLinkContext) {
        guard let userId = userId(from: notification) else { return }

        switch action(for: notification) {
        case .birthday, .none:
            // `nil` covers plain URL links (`bonjur://user?id=...`). New
            // actions branch here.
            showProfile(userId: userId, context: context)
        }
    }

    private func action(for notification: DeepLinkNotification) -> Action? {
        notification.action.flatMap(Action.init(rawValue:))
    }

    private func showProfile(userId: String, context: DeepLinkContext) {
        let module: ProfileModule = resolve()
        guard let viewController = module.makeProfileViewController(userId: userId) as? UIViewController else {
            return
        }
        show(viewController, with: context)
    }

    private func userId(from notification: DeepLinkNotification) -> String? {
        guard let id = notification.payload?[PayloadKey.id.rawValue] as? String,
              !id.isEmpty else { return nil }
        return id
    }
}
