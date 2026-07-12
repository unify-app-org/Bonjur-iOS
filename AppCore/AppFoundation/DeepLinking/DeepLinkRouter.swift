//
//  DeepLinkRouter.swift
//  AppFoundation
//
//  Created by Huseyn Hasanov on 10.07.26.
//

import Foundation

/// One per feature module. The module owns its screens, so it also owns the
/// deep-link routing into them: implement this in the module's Impl target and
/// register it with the shared `DeepLinkRegistrar` during DI setup.
public protocol DeepLinkRouter {
    /// The `identifier` this router answers to (e.g. "club", "event", "user").
    var deepLinkIdentifier: String { get }
    var isAuthenticationRequired: Bool { get }

    func canProcess(notification: DeepLinkNotification) -> Bool
    func process(notification: DeepLinkNotification, context: DeepLinkContext)
}
