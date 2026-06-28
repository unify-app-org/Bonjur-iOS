//
//  NotificationEndPoint.swift
//  NotificationImpl
//
//  Created by Huseyn Hasanov on 28.06.26.
//

import AppNetwork

/// Real endpoints backing the "Needs your action" screen. The notification feed
/// itself is still mock (see `NotificationMockDataSource`); only the join-request
/// counts/list are live for now.
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

/// Approve/reject a club's verification request. `status` ∈ {"ACCEPT", "REJECT"}.
struct ClubVerificationStatusBody: Encodable {
    let clubId: Int
    let status: String
}

enum NotificationEndPoint {
    /// Pending club join requests for clubs the caller organizes.
    case clubJoinRequests([String: String])
    /// Pending hangout join requests for hangouts the caller organizes.
    case hangoutJoinRequests([String: String])
    /// Accept/reject a club request.
    case setClubRequestStatus(ClubRequestStatusBody)
    /// Accept/reject a hangout request (hangout id is in the path).
    case setHangoutRequestStatus(hangoutId: String, body: HangoutRequestStatusBody)
    /// Admin: clubs awaiting verification.
    case clubPending([String: String])
    /// Admin: approve/reject a club's verification.
    case setClubVerification(ClubVerificationStatusBody)
}

extension NotificationEndPoint: AppEndPoint {

    var path: String {
        switch self {
        case .clubJoinRequests:
            "api/cs/v1/clubs/join-requests"
        case .hangoutJoinRequests:
            "api/hs/v1/hangouts/join-requests"
        case .setClubRequestStatus:
            "api/cs/v1/clubs/join-requests/status"
        case .setHangoutRequestStatus(let hangoutId, _):
            "api/hs/v1/hangouts/requests/\(hangoutId)"
        case .clubPending:
            "api/cs/v1/clubs/pending"
        case .setClubVerification:
            "api/cs/v1/clubs/status"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .clubJoinRequests, .hangoutJoinRequests, .clubPending:
            .get
        case .setClubRequestStatus, .setHangoutRequestStatus, .setClubVerification:
            .post
        }
    }

    var queryParameters: [String: String]? {
        switch self {
        case .clubJoinRequests(let query),
                .hangoutJoinRequests(let query),
                .clubPending(let query):
            query
        case .setClubRequestStatus, .setHangoutRequestStatus, .setClubVerification:
            nil
        }
    }

    var body: Encodable? {
        switch self {
        case .setClubRequestStatus(let body):
            body
        case .setHangoutRequestStatus(_, let body):
            body
        case .setClubVerification(let body):
            body
        default:
            nil
        }
    }
}
