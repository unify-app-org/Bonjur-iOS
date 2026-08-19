//
//  NotificationDTO.swift
//  NotificationImpl
//
//  Created by Huseyn Hasanov on 10.07.26.
//

import Foundation

/// `GET api/ns/v1/notifications` content row.
/// `note` is not sent by the backend (the spec has it as the admin's extra
/// remark) — the live payload carries that remark inside `metadata` instead,
/// so the mapper falls back to `metadata.rejectionReason`.
/// `createdAt` is the house stamp `dd-MM-yyyy HH:mm:ss`, not ISO — see
/// `RelativeTime.parse`.
struct NotificationDTO: Decodable {
    let id: Int?
    let type: String?
    let title: String?
    let body: String?
    let note: String?
    let imageUrl: String?
    let isRead: Bool?
    let createdAt: String?
    let targetType: String?
    let targetId: String?
    let metadata: NotificationMetadataDTO?
}

/// Per-type extras. Arrives as `null`, `{}` or a populated object; every field
/// is optional because which keys ride along depends on the notification type.
struct NotificationMetadataDTO: Decodable {
    /// Verification/join rejection remark — rendered as the row's note.
    let rejectionReason: String?
    /// Reminder lead time, e.g. `FIFTEEN_MINUTES_BEFORE` (unused by the UI).
    let reminderTime: String?
}

/// `GET api/ns/v1/notifications/unread-count` response.
struct UnreadCountDTO: Decodable {
    let count: Int?
}
