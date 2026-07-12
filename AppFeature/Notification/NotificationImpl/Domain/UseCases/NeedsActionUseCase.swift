//
//  NeedsActionUseCase.swift
//  NotificationImpl
//
//  Created by Huseyn Hasanov on 28.06.26.
//

import AppNetwork

/// A single source's page result, ready for the view model to accumulate.
struct RequestPageResult {
    let items: [ActionRequestItem]
    let hasMore: Bool
}

protocol NeedsActionUseCase {
    func fetchClubRequests(page: Int, size: Int) async throws(APIError) -> RequestPageResult
    func fetchHangoutRequests(page: Int, size: Int) async throws(APIError) -> RequestPageResult
    func fetchEventRequests(page: Int, size: Int) async throws(APIError) -> RequestPageResult
    /// Accept (`true`) or reject (`false`) a club join request.
    func setClubStatus(clubId: Int, userId: String, accept: Bool) async throws(APIError)
    /// Accept (`true`) or reject (`false`) a hangout join request.
    func setHangoutStatus(hangoutId: String, userId: String, accept: Bool) async throws(APIError)
    /// Accept (`true`) or reject (`false`) an event join request.
    func setEventStatus(eventId: String, userId: String, accept: Bool) async throws(APIError)
    /// Admin-only pending-verification total. Throwing (e.g. 403) means the
    /// caller isn't an admin — the banner stays hidden.
    func fetchVerificationCount() async throws(APIError) -> Int
}

final class NeedsActionUseCaseImpl: NeedsActionUseCase {

    private let dataSource: JoinRequestDataSource

    init(dataSource: JoinRequestDataSource = resolve()) {
        self.dataSource = dataSource
    }

    func fetchClubRequests(page: Int, size: Int) async throws(APIError) -> RequestPageResult {
        let response = try await dataSource.fetchClubRequests(page: page, size: size)
        return RequestPageResult(
            items: response.content.compactMap(JoinRequestMapper.item(from:)),
            hasMore: response.hasMore
        )
    }

    func fetchHangoutRequests(page: Int, size: Int) async throws(APIError) -> RequestPageResult {
        let response = try await dataSource.fetchHangoutRequests(page: page, size: size)
        return RequestPageResult(
            items: response.content.compactMap(JoinRequestMapper.item(from:)),
            hasMore: response.hasMore
        )
    }

    func fetchEventRequests(page: Int, size: Int) async throws(APIError) -> RequestPageResult {
        let response = try await dataSource.fetchEventRequests(page: page, size: size)
        return RequestPageResult(
            items: response.content.compactMap(JoinRequestMapper.item(from:)),
            hasMore: response.hasMore
        )
    }

    func setClubStatus(clubId: Int, userId: String, accept: Bool) async throws(APIError) {
        try await dataSource.setClubStatus(clubId: clubId, userId: userId, accept: accept)
    }

    func setHangoutStatus(hangoutId: String, userId: String, accept: Bool) async throws(APIError) {
        try await dataSource.setHangoutStatus(hangoutId: hangoutId, userId: userId, accept: accept)
    }

    func setEventStatus(eventId: String, userId: String, accept: Bool) async throws(APIError) {
        try await dataSource.setEventStatus(eventId: eventId, userId: userId, accept: accept)
    }

    func fetchVerificationCount() async throws(APIError) -> Int {
        let response = try await dataSource.fetchPendingClubs(page: 0, size: 1)
        return response.totalElements ?? 0
    }
}
