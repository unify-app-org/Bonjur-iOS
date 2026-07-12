//
//  JoinRequestMapper.swift
//  NotificationImpl
//
//  Created by Huseyn Hasanov on 28.06.26.
//

import Foundation

/// Normalizes the two join-request DTO shapes into the shared
/// `ActionRequestItem`. Missing names fall back to neutral placeholders so a
/// partial row still renders rather than dropping.
enum JoinRequestMapper {

    static func item(from dto: ClubJoinRequestDTO) -> ActionRequestItem? {
        guard let clubId = dto.clubId else { return nil }
        return ActionRequestItem(
            id: "club-\(clubId)-\(dto.userId ?? UUID().uuidString)",
            kind: .club(id: clubId),
            requesterId: dto.userId,
            requesterName: dto.fullName ?? "Someone",
            targetName: dto.clubName ?? "a club",
            avatarURL: dto.fileUrl,
            createdAt: RelativeTime.parse(dto.createdAt)
        )
    }

    static func item(from dto: HangoutJoinRequestDTO) -> ActionRequestItem? {
        guard let hangoutId = dto.hangoutId else { return nil }
        return ActionRequestItem(
            id: "hangout-\(hangoutId)-\(dto.userId ?? UUID().uuidString)",
            kind: .hangout(id: hangoutId),
            requesterId: dto.userId,
            requesterName: dto.fullName ?? "Someone",
            targetName: dto.hangoutName ?? "a hangout",
            avatarURL: dto.userProfileUrl,
            createdAt: RelativeTime.parse(dto.createdAt)
        )
    }

    static func item(from dto: EventJoinRequestDTO) -> ActionRequestItem? {
        guard let eventId = dto.eventId else { return nil }
        return ActionRequestItem(
            id: "event-\(eventId)-\(dto.userId ?? UUID().uuidString)",
            kind: .event(id: eventId),
            requesterId: dto.userId,
            requesterName: dto.fullName ?? "Someone",
            targetName: dto.eventName ?? "an event",
            avatarURL: dto.userProfileUrl,
            createdAt: RelativeTime.parse(dto.createdAt)
        )
    }
}
