//
//  NotificationUseCase.swift
//  NotificationImpl
//
//  Created by Huseyn Hasanov on 27.06.26.
//

import AppNetwork

protocol NotificationUseCase {
    func fetchInbox() async throws(APIError) -> NotificationInbox
    func markAllRead() async throws(APIError)
    /// Live pending-request totals for the "Needs your action" banner.
    func fetchRequestCounts() async throws(APIError) -> ActionRequestCounts
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

    func fetchInbox() async throws(APIError) -> NotificationInbox {
        try await dataSource.getInbox()
    }

    func markAllRead() async throws(APIError) {
        try await dataSource.markAllRead()
    }

    /// Cheap `size=1` probes — we only read `totalElements` from each source.
    func fetchRequestCounts() async throws(APIError) -> ActionRequestCounts {
        let clubs = try await joinRequestDataSource.fetchClubRequests(page: 0, size: 1)
        let hangouts = try await joinRequestDataSource.fetchHangoutRequests(page: 0, size: 1)
        return ActionRequestCounts(
            clubs: clubs.totalElements ?? 0,
            hangouts: hangouts.totalElements ?? 0
        )
    }
}
