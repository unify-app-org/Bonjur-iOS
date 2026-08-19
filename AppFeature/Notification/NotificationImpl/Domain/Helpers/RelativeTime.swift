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

    /// The format notification-service actually emits: `19-08-2026 17:55:35`.
    /// Same house audit stamp clubs/events/communities already parse
    /// (`DateFormat.ddMMyyyyHHmmss`). No zone on the wire — it is server-local,
    /// so it is read as device-local like everywhere else in the app.
    private static let houseStamp: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US_POSIX")
        f.timeZone = .current
        f.dateFormat = "dd-MM-yyyy HH:mm:ss"
        return f
    }()

    /// Zone-less ISO stamps (`2026-06-27T12:30:00`) — the shape the API spec
    /// documents. Not what the live feed sends today; kept as a fallback.
    private static let zoneLessISO: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US_POSIX")
        f.timeZone = TimeZone(secondsFromGMT: 0)
        f.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return f
    }()

    /// Parses a server `createdAt` into a `Date`, or `nil` if unparseable.
    /// House format first (that is what the feed sends), then the ISO shapes.
    /// An unparseable stamp shows no time on the row and sinks it to the
    /// "Earlier" bucket, so keep this tolerant.
    static func parse(_ string: String?) -> Date? {
        guard let string, !string.isEmpty else { return nil }
        if let date = houseStamp.date(from: string) {
            return date
        }
        // "2026-06-27 12:30:00" — space instead of the ISO `T`.
        let normalized = string.replacingOccurrences(of: " ", with: "T")
        if let date = isoFractional.date(from: normalized) ?? iso.date(from: normalized) {
            return date
        }
        let withoutFraction = normalized.split(separator: ".").first.map(String.init) ?? normalized
        return zoneLessISO.date(from: withoutFraction)
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
