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

    static func item(from dto: NotificationDTO) -> NotificationFeedItem? {
        guard let id = dto.id else { return nil }
        let createdAt = RelativeTime.parse(dto.createdAt)
        return NotificationFeedItem(
            id: "\(id)",
            type: NotificationType(apiValue: dto.type ?? ""),
            title: dto.title ?? "",
            subtitle: dto.body ?? "",
            note: dto.note,
            imageURL: dto.imageUrl,
            timeAgo: createdAt.map { RelativeTime.short(from: $0) } ?? "",
            isRead: dto.isRead ?? true,
            targetType: NotificationTargetType(apiValue: dto.targetType ?? ""),
            targetId: dto.targetId,
            createdAt: createdAt
        )
    }

    /// Buckets keep the incoming (server, newest-first) order within each
    /// section; items without a parseable `createdAt` sink to "Earlier".
    static func sections(from items: [NotificationFeedItem], now: Date = Date()) -> [NotificationSection] {
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: now)
        let startOfYesterday = calendar.date(byAdding: .day, value: -1, to: startOfToday) ?? startOfToday
        let startOfWeekWindow = calendar.date(byAdding: .day, value: -7, to: startOfToday) ?? startOfToday

        var today: [NotificationFeedItem] = []
        var yesterday: [NotificationFeedItem] = []
        var thisWeek: [NotificationFeedItem] = []
        var earlier: [NotificationFeedItem] = []

        for item in items {
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
