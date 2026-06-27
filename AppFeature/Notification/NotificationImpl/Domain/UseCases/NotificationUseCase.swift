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
}

final class NotificationUseCaseImpl: NotificationUseCase {

    private let dataSource: NotificationDataSource

    init(dataSource: NotificationDataSource = resolve()) {
        self.dataSource = dataSource
    }

    func fetchInbox() async throws(APIError) -> NotificationInbox {
        try await dataSource.getInbox()
    }

    func markAllRead() async throws(APIError) {
        try await dataSource.markAllRead()
    }
}
