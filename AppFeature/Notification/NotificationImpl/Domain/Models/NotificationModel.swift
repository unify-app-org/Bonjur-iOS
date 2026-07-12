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
    case birthday
    case holiday
    case eventReminder
    case requestOutcome
    case verificationOutcome
    case general

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
    
    var apiValue: String? {
        switch self {
        case .birthday:            return "BIRTHDAY"
        case .holiday:             return "HOLIDAY"
        case .eventReminder:       return "EVENT_REMINDER"
        case .requestOutcome:      return "REQUEST_OUTCOME"
        case .verificationOutcome: return "VERIFICATION_OUTCOME"
        case .general:             return nil
        }
    }
    
    var prefersRemoteImage: Bool {
        switch self {
        case .birthday, .holiday, .general:
            return false
        case .eventReminder, .requestOutcome, .verificationOutcome:
            return true
        }
    }

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
