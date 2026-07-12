//
//  NotificationUseCase.swift
//  NotificationImpl
//
//  Created by Huseyn Hasanov on 27.06.26.
//

import AppNetwork

/// One page of the notification feed, already mapped to feed items.
struct NotificationFeedPage {
    let items: [NotificationFeedItem]
    let hasMore: Bool
}

protocol NotificationUseCase {
    func fetchFeedPage(page: Int, size: Int) async throws(APIError) -> NotificationFeedPage
    func markAllRead() async throws(APIError)
    /// Live pending-request totals for the "Needs your action" banner.
    func fetchRequestCounts() async throws(APIError) -> ActionRequestCounts
    /// Admin-only pending-verification total; throwing (403) means not an admin.
    func fetchVerificationCount() async throws(APIError) -> Int
}

final class NotificationUseCaseImpl: NotificationUseCase {

    private let dataSource: NotificationDataSource
    private let joinRequestDataSource: JoinRequestDataSource

    init(
        dataSource: NotificationDataSource = resolve(),
        joinRequestDataSource: JoinRequestDataSource = resolve()
    ) {
        self.dataSource = dataSource
        self.joinRequestDataSource = joinRequestDataSource
    }

    func fetchFeedPage(page: Int, size: Int) async throws(APIError) -> NotificationFeedPage {
        let response = try await dataSource.fetchFeed(page: page, size: size)
        return NotificationFeedPage(
            items: response.content.compactMap(NotificationFeedMapper.item(from:)),
            hasMore: response.hasMore
        )
    }

    func markAllRead() async throws(APIError) {
        try await dataSource.markAllRead()
    }

    /// Cheap `size=1` probes — we only read `totalElements` from each source.
    func fetchRequestCounts() async throws(APIError) -> ActionRequestCounts {
        let clubs = try await joinRequestDataSource.fetchClubRequests(page: 0, size: 1)
        let hangouts = try await joinRequestDataSource.fetchHangoutRequests(page: 0, size: 1)
        let events = try await joinRequestDataSource.fetchEventRequests(page: 0, size: 1)
        return ActionRequestCounts(
            clubs: clubs.totalElements ?? 0,
            hangouts: hangouts.totalElements ?? 0,
            events: events.totalElements ?? 0
        )
    }

    func fetchVerificationCount() async throws(APIError) -> Int {
        let response = try await joinRequestDataSource.fetchPendingClubs(page: 0, size: 1)
        return response.totalElements ?? 0
    }
}
