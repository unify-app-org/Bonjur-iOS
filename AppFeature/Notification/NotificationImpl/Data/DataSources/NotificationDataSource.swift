//
//  NotificationDataSource.swift
//  NotificationImpl
//
//  Created by Huseyn Hasanov on 27.06.26.
//

import Foundation
import AppNetwork

protocol NotificationDataSource {
    func getInbox() async throws(APIError) -> NotificationInbox
    func markAllRead() async throws(APIError)
}

/// MOCK source. Returns static inbox content so the screen can be built and
/// reviewed before the notification-service API lands. Swap this single impl
/// (to a `NetworkService<NotificationEndPoint>`) when the backend is ready —
/// the UseCase / ViewModel / View stay untouched.
final class NotificationMockDataSource: NotificationDataSource {

    func getInbox() async throws(APIError) -> NotificationInbox {
        NotificationInbox(
            action: .init(requests: 3, verifications: 3),
            sections: [
                NotificationSection(
                    title: "Today",
                    items: [
                        // BIRTHDAY → local icon (imageURL nil)
                        .init(
                            id: "1",
                            type: .birthday,
                            title: "It's Durdana's birthday today! 🎉",
                            subtitle: "Be the first to wish her a happy birthday and make her day special.",
                            note: nil,
                            imageURL: nil,
                            timeAgo: "2h",
                            isRead: false,
                            targetType: .user,
                            targetId: "3fa8..."
                        ),
                        // EVENT_REMINDER → remote club photo (falls back to local calendar)
                        .init(
                            id: "2",
                            type: .eventReminder,
                            title: "The Grandmasters events for 1 hours.",
                            subtitle: "Checkmate society club",
                            note: nil,
                            imageURL: "https://cdn.unify.az/clubs/8/logo.png",
                            timeAgo: "4h",
                            isRead: false,
                            targetType: .event,
                            targetId: "41"
                        ),
                        .init(
                            id: "3",
                            type: .eventReminder,
                            title: "90 Minutes events for 1 hours.",
                            subtitle: "Football club",
                            note: nil,
                            imageURL: "https://cdn.unify.az/clubs/12/logo.png",
                            timeAgo: "6h",
                            isRead: false,
                            targetType: .event,
                            targetId: "42"
                        ),
                        // VERIFICATION_OUTCOME → remote club photo + note (reject reason)
                        .init(
                            id: "4",
                            type: .verificationOutcome,
                            title: "Verification rejected",
                            subtitle: "Football club 4s couldn't be verified.",
                            note: "Logo doesn't match the registration document.",
                            imageURL: "https://cdn.unify.az/clubs/12/logo.png",
                            timeAgo: "7h",
                            isRead: true,
                            targetType: .club,
                            targetId: "12"
                        ),
                        // HOLIDAY → local icon
                        .init(
                            id: "5",
                            type: .holiday,
                            title: "Happy new year! 🥂",
                            subtitle: "Wishing you a great year ahead.",
                            note: nil,
                            imageURL: nil,
                            timeAgo: "8h",
                            isRead: true,
                            targetType: .none,
                            targetId: nil
                        )
                    ]
                )
            ]
        )
    }

    func markAllRead() async throws(APIError) {
        // no-op for the mock
    }
}
