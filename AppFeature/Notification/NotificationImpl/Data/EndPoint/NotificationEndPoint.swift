//
//  NotificationEndPoint.swift
//  NotificationImpl
//
//  Created by Huseyn Hasanov on 28.06.26.
//

import AppNetwork
import AppFoundation

/// Endpoints backing the notification feed (notification-service, `api/ns`) and
/// the "notif_needs_action".localized screen (club/hangout/event join requests).
/// Accept/reject a club join request. `status` ∈ {"ACCEPT", "REJECT"}.
struct ClubRequestStatusBody: Encodable {
    let clubId: Int
    let userId: String
    let status: String
}

/// Accept/reject a hangout join request. `status` ∈ {"ACCEPTED", "REJECTED"}
/// (hangout uses a different enum than clubs).
struct HangoutRequestStatusBody: Encodable {
    let userId: String
    let status: String
}

/// Accept/reject an event join request. `status` ∈ {"ACCEPTED", "PENDING",
/// "REJECTED", "LEFT"} (event id is in the path).
struct EventRequestStatusBody: Encodable {
    let userId: String
    let status: String
}

/// Approve/reject a club's verification request. `status` ∈ {"ACCEPT", "REJECT"}.
struct ClubVerificationStatusBody: Encodable {
    let clubId: Int
    let status: String
}

enum NotificationEndPoint {
    /// Paged notification feed for the current user.
    case feed([String: String])
    /// Unread notification total (bell badge).
    case unreadCount
    /// Marks every notification read.
    case readAll
    /// Marks a single notification read.
    case readSingle(notificationId: String)
    /// Pending club join requests for clubs the caller organizes.
    case clubJoinRequests([String: String])
    /// Pending hangout join requests for hangouts the caller organizes.
    case hangoutJoinRequests([String: String])
    /// Pending event join requests for events the caller organizes.
    case eventJoinRequests([String: String])
    /// Accept/reject a club request.
    case setClubRequestStatus(ClubRequestStatusBody)
    /// Accept/reject a hangout request (hangout id is in the path).
    case setHangoutRequestStatus(hangoutId: String, body: HangoutRequestStatusBody)
    /// Accept/reject an event request (event id is in the path).
    case setEventRequestStatus(eventId: String, body: EventRequestStatusBody)
    /// Admin: clubs awaiting verification.
    case clubPending([String: String])
    /// Admin: approve/reject a club's verification.
    case setClubVerification(ClubVerificationStatusBody)
}

extension NotificationEndPoint: AppEndPoint {

    var path: String {
        switch self {
        case .feed:
            "api/ns/v1/notifications"
        case .unreadCount:
            "api/ns/v1/notifications/unread-count"
        case .readAll:
            "api/ns/v1/notifications/read-all"
        case .readSingle(let notificationId):
            "api/ns/v1/notifications/read/\(notificationId)"
        case .clubJoinRequests:
            "api/cs/v1/clubs/join-requests"
        case .hangoutJoinRequests:
            "api/hs/v1/hangouts/join-requests"
        case .eventJoinRequests:
            "api/es/v1/events/requests"
        case .setClubRequestStatus:
            "api/cs/v1/clubs/join-requests/status"
        case .setHangoutRequestStatus(let hangoutId, _):
            "api/hs/v1/hangouts/requests/\(hangoutId)"
        case .setEventRequestStatus(let eventId, _):
            "api/es/v1/events/\(eventId)"
        case .clubPending:
            "api/cs/v1/clubs/pending"
        case .setClubVerification:
            "api/cs/v1/clubs/status"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .feed, .unreadCount, .clubJoinRequests, .hangoutJoinRequests, .eventJoinRequests, .clubPending:
            .get
        case .readAll, .readSingle, .setClubRequestStatus, .setHangoutRequestStatus, .setEventRequestStatus, .setClubVerification:
            .post
        }
    }

    var queryParameters: [String: String]? {
        switch self {
        case .feed(let query),
                .clubJoinRequests(let query),
                .hangoutJoinRequests(let query),
                .eventJoinRequests(let query),
                .clubPending(let query):
            query
        case .unreadCount, .readAll, .readSingle, .setClubRequestStatus, .setHangoutRequestStatus, .setEventRequestStatus, .setClubVerification:
            nil
        }
    }

    var body: Encodable? {
        switch self {
        case .setClubRequestStatus(let body):
            body
        case .setHangoutRequestStatus(_, let body):
            body
        case .setEventRequestStatus(_, let body):
            body
        case .setClubVerification(let body):
            body
        default:
            nil
        }
    }
}
