//
//  NotificationDTO.swift
//  NotificationImpl
//
//  Created by Huseyn Hasanov on 10.07.26.
//

import Foundation

/// `GET api/ns/v1/notifications` content row.
/// `note` is not sent by the backend yet (spec has it as the admin's extra
/// remark, e.g. a verification reject reason) — decoded optionally so the UI
/// lights up as soon as the field ships.
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
}

/// `GET api/ns/v1/notifications/unread-count` response.
struct UnreadCountDTO: Decodable {
    let count: Int?
}
