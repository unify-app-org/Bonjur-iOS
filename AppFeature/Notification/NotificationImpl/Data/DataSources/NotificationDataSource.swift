//
//  NotificationDataSource.swift
//  NotificationImpl
//
//  Created by Huseyn Hasanov on 27.06.26.
//

import Foundation
import AppNetwork

protocol NotificationDataSource {
    func fetchFeed(page: Int, size: Int) async throws(APIError) -> JoinRequestPage<NotificationDTO>
    func fetchUnreadCount() async throws(APIError) -> Int
    func markAllRead() async throws(APIError)
    func markRead(id: String) async throws(APIError)
}

/// Live notification-service source (`api/ns`). Decodes the Spring `Page<T>`
/// shape directly (no `BaseResponse` envelope, same as the join-request APIs).
final class NotificationNetworkDataSource: NetworkService<NotificationEndPoint>, NotificationDataSource {

    func fetchFeed(page: Int, size: Int) async throws(APIError) -> JoinRequestPage<NotificationDTO> {
        try await fetch(endPoint: .feed(["page": "\(page)", "size": "\(size)"]))
    }

    func fetchUnreadCount() async throws(APIError) -> Int {
        let response: UnreadCountDTO = try await fetch(endPoint: .unreadCount)
        return response.count ?? 0
    }

    func markAllRead() async throws(APIError) {
        _ = try await fetchRawData(endPoint: .readAll)
    }

    func markRead(id: String) async throws(APIError) {
        _ = try await fetchRawData(endPoint: .readSingle(notificationId: id))
    }
}
