//
//  EventsDeepLinkRouter.swift
//  EventsImpl
//
//  Created by Huseyn Hasanov on 10.07.26.
//

import UIKit
import Events
import AppFoundation

/// Deep links into the Events module. Registered with the shared
/// `DeepLinkRegistrar` during module DI setup.
/// Matches notification `targetType: EVENT` (identifier "event", payload `id`);
/// the notification `type` arrives as the `action` and picks the screen.
final class EventsDeepLinkRouter: DeepLinkRouter {
    /// Notification-service `type` values that target an event.
    private enum Action: String {
        /// "Starts in 1 hour" reminder — land on the event.
        case eventReminder = "EVENT_REMINDER"
    }

    private enum PayloadKey: String {
        case id
    }

    let deepLinkIdentifier = "event"
    let isAuthenticationRequired = true

    func canProcess(notification: DeepLinkNotification) -> Bool {
        notification.identifier == deepLinkIdentifier
            && eventId(from: notification) != nil
    }

    func process(notification: DeepLinkNotification, context: DeepLinkContext) {
        guard let eventId = eventId(from: notification) else { return }

        switch action(for: notification) {
        case .eventReminder, .none:
            // `nil` covers plain URL links (`bonjur://event?id=...`). New
            // actions branch here.
            showDetails(eventId: eventId, context: context)
        }
    }

    private func action(for notification: DeepLinkNotification) -> Action? {
        notification.action.flatMap(Action.init(rawValue:))
    }

    private func showDetails(eventId: String, context: DeepLinkContext) {
        let module: EventsModule = resolve()
        guard let viewController = module.makeEventsDetails(eventId: eventId) as? UIViewController else {
            return
        }
        show(viewController, with: context)
    }

    private func eventId(from notification: DeepLinkNotification) -> String? {
        guard let id = notification.payload?[PayloadKey.id.rawValue] as? String,
              !id.isEmpty else { return nil }
        return id
    }
}
