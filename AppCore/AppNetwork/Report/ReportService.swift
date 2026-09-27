//
//  ReportService.swift
//  AppNetwork
//
//  One endpoint reports every kind of target (user / event / club / hangout):
//  POST api/us/v1/users/reports. Lives in core because member reports are
//  raised from every activity's member list, not from one feature.
//

import Foundation

// MARK: - Target

/// What is being reported. Each case carries the id in the type the backend
/// expects for it — clubs are numeric, everything else is a UUID string.
public enum ReportTarget: Equatable {
    case user(id: String)
    case event(id: String)
    case club(id: Int)
    case hangout(id: String)
}

// MARK: - Service

public protocol ReportService {
    /// - Parameters:
    ///   - reason: the reason code (e.g. `SPAM`, `FAKE_PROFILE`).
    ///   - details: free text for moderators.
    func report(
        _ target: ReportTarget,
        reason: String,
        details: String?
    ) async throws(APIError)
}

final class ReportServiceImpl: NetworkService<ReportEndPoint>, ReportService {

    func report(
        _ target: ReportTarget,
        reason: String,
        details: String?
    ) async throws(APIError) {
        let request = ReportRequest(target: target, reason: reason, details: details)
        _ = try await fetchRawData(endPoint: .report(request))
    }
}

// MARK: - Endpoint

enum ReportEndPoint: AppEndPoint {
    case report(ReportRequest)

    var path: String {
        switch self {
        case .report:
            "api/us/v1/users/reports"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .report:
            .post
        }
    }

    var body: Encodable? {
        switch self {
        case .report(let request):
            request
        }
    }
}

// MARK: - Request

/// Only the id matching `reportType` is set; the synthesized encoder skips
/// the `nil` ones, so the other three never reach the wire.
struct ReportRequest: Encodable {
    struct Reason: Encodable {
        let reason: String
        let details: String?
    }

    let request: Reason
    let reportType: String
    let reportedUserId: String?
    let reportedEventId: String?
    let reportedClubId: Int?
    let reportedHangoutId: String?

    init(target: ReportTarget, reason: String, details: String?) {
        request = .init(reason: reason, details: details)
        var userId: String?
        var eventId: String?
        var clubId: Int?
        var hangoutId: String?
        switch target {
        case .user(let id):
            reportType = "USER"
            userId = id
        case .event(let id):
            reportType = "EVENT"
            eventId = id
        case .club(let id):
            reportType = "CLUB"
            clubId = id
        case .hangout(let id):
            reportType = "HANGOUT"
            hangoutId = id
        }
        reportedUserId = userId
        reportedEventId = eventId
        reportedClubId = clubId
        reportedHangoutId = hangoutId
    }
}
