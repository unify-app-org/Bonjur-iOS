//
//  ClubsDeepLinkRouter.swift
//  ClubsImpl
//
//  Created by Huseyn Hasanov on 10.07.26.
//

import UIKit
import Clubs
import AppFoundation

/// Deep links into the Clubs module. Registered with the shared
/// `DeepLinkRegistrar` during module DI setup.
/// Matches notification `targetType: CLUB` (identifier "club", payload `id`);
/// the notification `type` arrives as the `action` and picks the screen.
final class ClubsDeepLinkRouter: DeepLinkRouter {
    /// Notification-service `type` values that target a club.
    private enum Action: String {
        /// Join request accepted/rejected — land on the club.
        case requestOutcome = "REQUEST_OUTCOME"
        /// Verify decision on the owner's club — land on the club, where the
        /// verify seal / request-verify state is visible.
        case verificationOutcome = "VERIFICATION_OUTCOME"
    }

    private enum PayloadKey: String {
        case id
    }

    let deepLinkIdentifier = "club"
    let isAuthenticationRequired = true

    func canProcess(notification: DeepLinkNotification) -> Bool {
        notification.identifier == deepLinkIdentifier
            && clubId(from: notification) != nil
    }

    func process(notification: DeepLinkNotification, context: DeepLinkContext) {
        guard let clubId = clubId(from: notification) else { return }

        switch action(for: notification) {
        case .requestOutcome, .verificationOutcome, .none:
            // All club-targeted outcomes resolve to the detail screen today;
            // `nil` covers plain URL links (`bonjur://club?id=12`). New actions
            // (e.g. a dedicated verification-status screen) branch here.
            showDetails(clubId: clubId, context: context)
        }
    }

    private func action(for notification: DeepLinkNotification) -> Action? {
        notification.action.flatMap(Action.init(rawValue:))
    }

    private func showDetails(clubId: Int, context: DeepLinkContext) {
        let module: ClubsModule = resolve()
        guard let viewController = module.makeClubsDetailsVC(clubId: clubId) as? UIViewController else {
            return
        }
        show(viewController, with: context)
    }

    /// Club ids are numeric but arrive as strings from URLs/notifications.
    private func clubId(from notification: DeepLinkNotification) -> Int? {
        switch notification.payload?[PayloadKey.id.rawValue] {
        case let intValue as Int: intValue
        case let stringValue as String: Int(stringValue)
        default: nil
        }
    }
}
