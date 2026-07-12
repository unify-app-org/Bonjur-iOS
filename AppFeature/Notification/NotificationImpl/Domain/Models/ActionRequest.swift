//
//  ActionRequest.swift
//  NotificationImpl
//
//  Created by Huseyn Hasanov on 28.06.26.
//

import Foundation

// MARK: - Kind

/// Which entity a pending request targets, carrying the id needed to deep-link
/// into that entity's detail screen.
enum ActionRequestKind: Equatable {
    case club(id: Int)
    case hangout(id: String)
    case event(id: String)
}

// MARK: - Item

/// A single pending join request, normalized across the club + hangout
/// endpoints into one row the "Requests" tab can render and sort.
struct ActionRequestItem: Identifiable, Equatable {
    let id: String
    let kind: ActionRequestKind
    /// Requester's user id — needed to accept (assign membership role).
    let requesterId: String?
    /// Who asked to join.
    let requesterName: String
    /// The club/hangout they want to join.
    let targetName: String
    /// Requester's profile photo (club `fileUrl` / hangout `userProfileUrl`).
    let avatarURL: String?
    /// Parsed `createdAt`; `nil` if the server omitted/!parsed it. Used for sort.
    let createdAt: Date?

    /// "Aysu wants to join Chess club"
    var title: String {
        "\(requesterName) wants to join \(targetName)"
    }

    /// Short relative stamp ("2h", "3d"). Empty when `createdAt` is missing.
    var timeAgo: String {
        guard let createdAt else { return "" }
        return RelativeTime.short(from: createdAt)
    }
}

// MARK: - Page result

// MARK: - Counts

/// Total pending counts for the banner (`totalElements` from each source).
struct ActionRequestCounts {
    let clubs: Int
    let hangouts: Int
    let events: Int

    var total: Int { clubs + hangouts + events }
}
