//
//  HangoutsDeepLinkRouter.swift
//  HangoutsImpl
//
//  Created by Huseyn Hasanov on 19.08.26.
//

import UIKit
import Hangouts
import AppFoundation

/// Deep links into the Hangouts module. Registered with the shared
/// `DeepLinkRegistrar` during module DI setup.
/// Matches notification `targetType: HANGOUT` (identifier "hangout", payload
/// `id`); the notification `type` arrives as the `action` and picks the screen.
final class HangoutsDeepLinkRouter: DeepLinkRouter {
    /// Notification-service `type` values that target a hangout.
    private enum Action: String {
        /// The user's own join request was accepted/rejected.
        case acceptedUserFromHangout = "ACCEPTED_USER_FROM_HANGOUT"
        case rejectedUserFromHangout = "REJECTED_USER_FROM_HANGOUT"
        /// Someone joined a public hangout the user organizes.
        case userJoinedPublicHangout = "USER_JOINED_PUBLIC_HANGOUT"
    }

    private enum PayloadKey: String {
        case id
    }

    let deepLinkIdentifier = "hangout"
    let isAuthenticationRequired = true

    func canProcess(notification: DeepLinkNotification) -> Bool {
        notification.identifier == deepLinkIdentifier
            && hangoutId(from: notification) != nil
    }

    func process(notification: DeepLinkNotification, context: DeepLinkContext) {
        guard let hangoutId = hangoutId(from: notification) else { return }

        switch action(for: notification) {
        case .acceptedUserFromHangout, .rejectedUserFromHangout, .userJoinedPublicHangout, .none:
            // All hangout-targeted types resolve to the detail screen today;
            // `nil` covers plain URL links (`bonjur://hangout?id=...`). New
            // actions (e.g. a member list) branch here.
            showDetails(hangoutId: hangoutId, context: context)
        }
    }

    private func action(for notification: DeepLinkNotification) -> Action? {
        notification.action.flatMap(Action.init(rawValue:))
    }

    private func showDetails(hangoutId: String, context: DeepLinkContext) {
        let module: HangoutsModule = resolve()
        guard let viewController = module.makeHangoutDetails(hangoutId: hangoutId) as? UIViewController else {
            return
        }
        show(viewController, with: context)
    }

    private func hangoutId(from notification: DeepLinkNotification) -> String? {
        guard let id = notification.payload?[PayloadKey.id.rawValue] as? String,
              !id.isEmpty else { return nil }
        return id
    }
}
