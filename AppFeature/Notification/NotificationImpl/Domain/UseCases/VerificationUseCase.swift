//
//  VerificationUseCase.swift
//  NotificationImpl
//
//  Created by Huseyn Hasanov on 28.06.26.
//

import AppNetwork

struct VerificationPageResult {
    let items: [VerificationItem]
    let hasMore: Bool
}

protocol VerificationUseCase {
    func fetchPending(page: Int, size: Int) async throws(APIError) -> VerificationPageResult
    /// Approve (`true`) or reject (`false`) a club's verification.
    func setStatus(clubId: Int, accept: Bool) async throws(APIError)
}

final class VerificationUseCaseImpl: VerificationUseCase {

    private let dataSource: JoinRequestDataSource

    init(dataSource: JoinRequestDataSource = resolve()) {
        self.dataSource = dataSource
    }

    func fetchPending(page: Int, size: Int) async throws(APIError) -> VerificationPageResult {
        let response = try await dataSource.fetchPendingClubs(page: page, size: size)
        return VerificationPageResult(
            items: response.content.compactMap(JoinRequestMapper.verification(from:)),
            hasMore: response.hasMore
        )
    }

    func setStatus(clubId: Int, accept: Bool) async throws(APIError) {
        try await dataSource.setClubVerification(clubId: clubId, accept: accept)
    }
}
