//
//  VerificationItem.swift
//  NotificationImpl
//
//  Created by Huseyn Hasanov on 28.06.26.
//

import Foundation

/// A club awaiting admin verification. Backed by `/v1/clubs/pending`, whose row
/// shape matches the club join-request DTO (here `fileUrl` is the club logo).
struct VerificationItem: Identifiable, Equatable {
    let id: String
    let clubId: Int
    let clubName: String
    /// Who submitted the club for verification.
    let submitterName: String
    /// Club logo.
    let logoURL: String?
}

extension JoinRequestMapper {
    static func verification(from dto: ClubJoinRequestDTO) -> VerificationItem? {
        guard let clubId = dto.clubId else { return nil }
        return VerificationItem(
            id: "verif-\(clubId)",
            clubId: clubId,
            clubName: dto.clubName ?? "A club",
            submitterName: dto.fullName ?? "Someone",
            logoURL: dto.fileUrl
        )
    }
}
