//
//  NotificationModel.swift
//  NotificationImpl
//
//  Created by Huseyn Hasanov on 27.06.26.
//

import UIKit
import AppUIKit

// MARK: - Inbox

/// Full payload backing the notification inbox screen: the "Needs your action"
/// summary (banner) plus the read-only feed grouped into time sections.
struct NotificationInbox {
    var action: NeedsActionSummary
    var sections: [NotificationSection]

    static let empty = NotificationInbox(
        action: .init(requests: 0, verifications: 0),
        sections: []
    )
}

// MARK: - Needs your action (banner)

/// Client-composed count. Join requests live in club/hangout/event services,
/// verifications in the verification service; the banner just sums them.
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

/// Mirrors `NotificationResponse` from the notification-service spec
/// (see notification-verification-api-spec.md §3.1).
struct NotificationFeedItem: Identifiable {
    let id: String
    let type: NotificationType
    let title: String
    /// `body` in the API.
    let subtitle: String
    /// Optional extra context (e.g. admin reject reason). Shown under `subtitle`.
    let note: String?
    /// Remote `imageUrl` from the API. May be `nil` (then the local type icon shows).
    let imageURL: String?
    let timeAgo: String
    var isRead: Bool

    let targetType: NotificationTargetType
    let targetId: String?

    var isUnread: Bool { !isRead }

    /// Resolves to a remote image when the type points at a real entity and a
    /// URL is present; otherwise a local SF Symbol icon. (Spec: BIRTHDAY/HOLIDAY
    /// are always local, the rest prefer the remote club/user image.)
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
    case birthday
    case holiday
    case eventReminder
    case requestOutcome
    case verificationOutcome
    /// Default / unknown type — uses the bell icon.
    case general

    /// Maps the API string (`BIRTHDAY`, `EVENT_REMINDER`, ...). Unknown → `.general`.
    init(apiValue: String) {
        switch apiValue.uppercased() {
        case "BIRTHDAY":             self = .birthday
        case "HOLIDAY":              self = .holiday
        case "EVENT_REMINDER":       self = .eventReminder
        case "REQUEST_OUTCOME":      self = .requestOutcome
        case "VERIFICATION_OUTCOME": self = .verificationOutcome
        default:                     self = .general
        }
    }

    /// Outcome/event types reference a real entity → use its remote photo.
    /// Birthday/holiday/general are platform-generic → always the local icon.
    var prefersRemoteImage: Bool {
        switch self {
        case .birthday, .holiday, .general:
            return false
        case .eventReminder, .requestOutcome, .verificationOutcome:
            return true
        }
    }

    /// SF Symbol name for the local icon (clean, crisp at any size).
    var iconSystemName: String {
        switch self {
        case .birthday:            return "gift.fill"
        case .holiday:             return "party.popper.fill"
        case .eventReminder:       return "calendar"
        case .requestOutcome:      return "person.2.fill"
        case .verificationOutcome: return "checkmark.seal.fill"
        case .general:             return "bell.fill"
        }
    }
}

// MARK: - Target (matches API `targetType`)

enum NotificationTargetType {
    case event
    case club
    case user
    case none

    init(apiValue: String) {
        switch apiValue.uppercased() {
        case "EVENT": self = .event
        case "CLUB":  self = .club
        case "USER":  self = .user
        default:      self = .none
        }
    }
}
