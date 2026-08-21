//
//  NotificationFeedMapper.swift
//  NotificationImpl
//
//  Created by Huseyn Hasanov on 10.07.26.
//

import Foundation
import AppFoundation

/// Maps notification-service rows into feed items and groups a flat page
/// stream into the date buckets the feed renders (Today / Yesterday /
/// This week / Earlier).
enum NotificationFeedMapper {

    /// Rejection outcomes are the only rows whose note box carries the admin reason.
    private static let rejectionTypes: Set<NotificationType> = [
        .rejectedUserFromClub,
        .rejectedClubVerification,
        .rejectedUserFromHangout,
        .rejectedUserFromEvent
    ]

    static func item(from dto: NotificationDTO) -> NotificationFeedItem? {
        guard let id = dto.id else { return nil }
        let createdAt = RelativeTime.parse(dto.createdAt)
        let type = NotificationType(apiValue: dto.type ?? "")
        // `metadata.rejectionReason` is only meaningful on a rejection — the
        // backend also stamps it on SUCCESS rows, which used to render a stray
        // note box under "Club verified".
        let rejectionNote = rejectionTypes.contains(type) ? dto.metadata?.rejectionReason : nil
        return NotificationFeedItem(
            id: "\(id)",
            type: type,
            title: dto.title ?? "",
            subtitle: dto.body ?? "",
            note: dto.note ?? rejectionNote,
            imageURL: dto.imageUrl,
            timeAgo: createdAt.map { RelativeTime.short(from: $0) } ?? "",
            isRead: dto.isRead ?? true,
            targetType: NotificationTargetType(apiValue: dto.targetType ?? ""),
            targetId: dto.targetId,
            createdAt: createdAt
        )
    }

    /// Newest first; rows missing `createdAt` keep their relative order and
    /// sink to the bottom (they also bucket into "Earlier"). The server order
    /// is not relied on — pages are concatenated as they load, so the merged
    /// list has to be sorted client-side.
    static func sorted(_ items: [NotificationFeedItem]) -> [NotificationFeedItem] {
        // Pages can overlap when rows arrive between requests; a repeated id
        // would render twice (and collide as an `Identifiable` id).
        var seen = Set<String>()
        let unique = items.filter { seen.insert($0.id).inserted }
        return unique.enumerated().sorted { lhs, rhs in
            switch (lhs.element.createdAt, rhs.element.createdAt) {
            case let (l?, r?):
                return l == r ? lhs.offset < rhs.offset : l > r
            case (_?, nil):
                return true
            case (nil, _?):
                return false
            case (nil, nil):
                return lhs.offset < rhs.offset
            }
        }
        .map(\.element)
    }

    /// Buckets are filled newest-first; items without a parseable `createdAt`
    /// sink to "Earlier".
    static func sections(from items: [NotificationFeedItem], now: Date = Date()) -> [NotificationSection] {
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: now)
        let startOfYesterday = calendar.date(byAdding: .day, value: -1, to: startOfToday) ?? startOfToday
        let startOfWeekWindow = calendar.date(byAdding: .day, value: -7, to: startOfToday) ?? startOfToday

        var today: [NotificationFeedItem] = []
        var yesterday: [NotificationFeedItem] = []
        var thisWeek: [NotificationFeedItem] = []
        var earlier: [NotificationFeedItem] = []

        for item in sorted(items) {
            guard let date = item.createdAt else {
                earlier.append(item)
                continue
            }
            if date >= startOfToday {
                today.append(item)
            } else if date >= startOfYesterday {
                yesterday.append(item)
            } else if date >= startOfWeekWindow {
                thisWeek.append(item)
            } else {
                earlier.append(item)
            }
        }

        return [
            ("notif_today".localized, today),
            ("notif_yesterday".localized, yesterday),
            ("notif_this_week".localized, thisWeek),
            ("notif_earlier".localized, earlier)
        ]
        .filter { !$0.1.isEmpty }
        .map { NotificationSection(title: $0.0, items: $0.1) }
    }
}
