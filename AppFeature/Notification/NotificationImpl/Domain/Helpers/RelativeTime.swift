//
//  RelativeTime.swift
//  NotificationImpl
//
//  Created by Huseyn Hasanov on 28.06.26.
//

import Foundation

/// Tiny relative-time formatter for join-request `createdAt` stamps. Produces
/// compact units ("now", "5m", "2h", "3d", "2w") to match the notification feed
/// rows. No existing app util covered this, so it lives with the feature.
enum RelativeTime {

    /// ISO-8601 parser tolerant of fractional seconds (Spring `Instant`s often
    /// serialize with them, sometimes without).
    private static let isoFractional: ISO8601DateFormatter = {
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return f
    }()

    private static let iso: ISO8601DateFormatter = {
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withInternetDateTime]
        return f
    }()

    /// Parses a server `createdAt` string into a `Date`, or `nil` if unparseable.
    static func parse(_ string: String?) -> Date? {
        guard let string, !string.isEmpty else { return nil }
        return isoFractional.date(from: string) ?? iso.date(from: string)
    }

    /// Compact relative stamp from `date` to `reference` (default: now).
    static func short(from date: Date, to reference: Date = Date()) -> String {
        let seconds = max(0, reference.timeIntervalSince(date))
        switch seconds {
        case ..<60:           return "now"
        case ..<3_600:        return "\(Int(seconds / 60))m"
        case ..<86_400:       return "\(Int(seconds / 3_600))h"
        case ..<604_800:      return "\(Int(seconds / 86_400))d"
        default:              return "\(Int(seconds / 604_800))w"
        }
    }
}
