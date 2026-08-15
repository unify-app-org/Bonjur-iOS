//
//  NotificationModel.swift
//  NotificationImpl
//
//  Created by Huseyn Hasanov on 27.06.26.
//

import UIKit
import AppUIKit

// MARK: - Inbox

struct NotificationInbox {
    var action: NeedsActionSummary
    var sections: [NotificationSection]

    static let empty = NotificationInbox(
        action: .init(requests: 0, verifications: 0),
        sections: []
    )
}

// MARK: - Needs your action (banner)

struct NeedsActionSummary {
    var requests: Int
    var verifications: Int

    var total: Int { requests + verifications }
    var hasActions: Bool { total > 0 }
}

// MARK: - Feed

struct NotificationSection: Identifiable {
    let id = UUID()
    let title: String
    var items: [NotificationFeedItem]
}

struct NotificationFeedItem: Identifiable {
    let id: String
    let type: NotificationType
    let title: String
    let subtitle: String
    let note: String?
    let imageURL: String?
    let timeAgo: String
    var isRead: Bool
    let targetType: NotificationTargetType
    let targetId: String?
    var createdAt: Date? = nil
    var isUnread: Bool { !isRead }
    var image: NotificationImageSource {
        if type.prefersRemoteImage,
           let urlString = imageURL,
           let url = URL(string: urlString) {
            return .remote(url)
        }
        return .local(systemName: type.iconSystemName)
    }
}

// MARK: - Image source

enum NotificationImageSource {
    case local(systemName: String)
    case remote(URL)
}

// MARK: - Type (matches API `type` enum)

enum NotificationType {
    case eventReminder
    case birthday
    case requestOutcome
    case verificationOutcome
    case holiday

    case requestClub
    case rejectedUserFromClub
    case acceptedUserFromClub
    case requestClubVerification
    case verifiedClub
    case rejectedClubVerification

    case requestHangout
    case rejectedUserFromHangout
    case acceptedUserFromHangout

    case rejectedUserFromEvent
    case acceptedUserFromEvent

    case general

    init(apiValue: String) {
        switch apiValue.uppercased() {
        case "EVENT_REMINDER":
            self = .eventReminder

        case "BIRTHDAY":
            self = .birthday

        case "REQUEST_OUTCOME":
            self = .requestOutcome

        case "VERIFICATION_OUTCOME":
            self = .verificationOutcome

        case "REQUEST_CLUB":
            self = .requestClub

        case "REJECTED_USER_FROM_CLUB":
            self = .rejectedUserFromClub

        case "ACCEPTED_USER_FROM_CLUB":
            self = .acceptedUserFromClub

        case "REQUEST_CLUB_VERIFICATION":
            self = .requestClubVerification

        case "VERIFIED_CLUB":
            self = .verifiedClub

        case "REJECTED_CLUB_VERIFICATION":
            self = .rejectedClubVerification

        case "REQUEST_HANGOUT":
            self = .requestHangout

        case "REJECTED_USER_FROM_HANGOUT":
            self = .rejectedUserFromHangout

        case "ACCEPTED_USER_FROM_HANGOUT":
            self = .acceptedUserFromHangout

        case "REJECTED_USER_FROM_EVENT":
            self = .rejectedUserFromEvent

        case "ACCEPTED_USER_FROM_EVENT":
            self = .acceptedUserFromEvent
            
        case "HOLIDAY":
            self = .holiday

        default:
            self = .general
        }
    }

    var apiValue: String? {
        switch self {
        case .eventReminder:
            return "EVENT_REMINDER"

        case .birthday:
            return "BIRTHDAY"

        case .requestOutcome:
            return "REQUEST_OUTCOME"

        case .verificationOutcome:
            return "VERIFICATION_OUTCOME"

        case .requestClub:
            return "REQUEST_CLUB"

        case .rejectedUserFromClub:
            return "REJECTED_USER_FROM_CLUB"

        case .acceptedUserFromClub:
            return "ACCEPTED_USER_FROM_CLUB"

        case .requestClubVerification:
            return "REQUEST_CLUB_VERIFICATION"

        case .verifiedClub:
            return "VERIFIED_CLUB"

        case .rejectedClubVerification:
            return "REJECTED_CLUB_VERIFICATION"

        case .requestHangout:
            return "REQUEST_HANGOUT"

        case .rejectedUserFromHangout:
            return "REJECTED_USER_FROM_HANGOUT"

        case .acceptedUserFromHangout:
            return "ACCEPTED_USER_FROM_HANGOUT"

        case .rejectedUserFromEvent:
            return "REJECTED_USER_FROM_EVENT"

        case .acceptedUserFromEvent:
            return "ACCEPTED_USER_FROM_EVENT"
            
        case .holiday:
            return "HOLIDAY"
            
        case .general:
            return nil
        }
    }

    var prefersRemoteImage: Bool {
        switch self {
        case .birthday, .general:
            return false

        default:
            return true
        }
    }

    /// Where tapping a notification of this type should go.
    enum TapDestination {
        /// The join-request / verification accept-reject screen.
        case needsAction
        /// The related club/hangout/event/community/user detail (via target).
        case target
        /// Informational — no navigation, only mark as read.
        case none
    }

    var tapDestination: TapDestination {
        switch self {
        // Incoming requests the user must act on.
        case .requestClub, .requestHangout, .requestClubVerification:
            return .needsAction
        // Purely informational — nowhere meaningful to go.
        case .birthday, .holiday, .general:
            return .none
        // Outcomes & reminders open the related detail.
        case .eventReminder, .requestOutcome, .verificationOutcome,
             .rejectedUserFromClub, .acceptedUserFromClub,
             .verifiedClub, .rejectedClubVerification,
             .rejectedUserFromHangout, .acceptedUserFromHangout,
             .rejectedUserFromEvent, .acceptedUserFromEvent:
            return .target
        }
    }

    var iconSystemName: String {
        switch self {
        case .holiday:
            return "gift.fill"

        case .birthday:
            return "gift.fill"

        case .eventReminder:
            return "calendar"

        case .requestOutcome:
            return "person.2.fill"

        case .verificationOutcome:
            return "checkmark.seal.fill"

        case .requestClub:
            return "person.badge.plus"

        case .rejectedUserFromClub:
            return "person.badge.minus"

        case .acceptedUserFromClub:
            return "person.badge.checkmark"

        case .requestClubVerification:
            return "checkmark.seal"

        case .verifiedClub:
            return "checkmark.seal.fill"

        case .rejectedClubVerification:
            return "xmark.seal.fill"

        case .requestHangout:
            return "person.2.badge.plus"

        case .rejectedUserFromHangout:
            return "person.badge.minus"

        case .acceptedUserFromHangout:
            return "person.badge.checkmark"

        case .rejectedUserFromEvent:
            return "calendar.badge.minus"

        case .acceptedUserFromEvent:
            return "calendar.badge.checkmark"

        case .general:
            return "bell.fill"
        }
    }
}

// MARK: - Target (matches API `targetType`)

enum NotificationTargetType {
    case event
    case club
    case hangout
    case community
    case user
    case none

    init(apiValue: String) {
        switch apiValue.uppercased() {
        case "EVENT": self = .event
        case "CLUB":  self = .club
        case "USER":  self = .user
        case "HANGOUT": self = .hangout
        case "COMMUNITY": self = .community
        default:      self = .none
        }
    }
}
