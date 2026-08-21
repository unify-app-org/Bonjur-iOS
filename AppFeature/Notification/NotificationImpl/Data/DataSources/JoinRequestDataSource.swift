//
//  JoinRequestDataSource.swift
//  NotificationImpl
//
//  Created by Huseyn Hasanov on 28.06.26.
//

import Foundation
import AppNetwork

protocol JoinRequestDataSource {
    func fetchClubRequests(page: Int, size: Int) async throws(APIError) -> JoinRequestPage<ClubJoinRequestDTO>
    func fetchHangoutRequests(page: Int, size: Int) async throws(APIError) -> JoinRequestPage<HangoutJoinRequestDTO>
    func fetchEventRequests(page: Int, size: Int) async throws(APIError) -> JoinRequestPage<EventJoinRequestDTO>
    func setClubStatus(clubId: Int, userId: String, accept: Bool) async throws(APIError)
    func setHangoutStatus(hangoutId: String, userId: String, accept: Bool) async throws(APIError)
    func setEventStatus(eventId: String, userId: String, accept: Bool) async throws(APIError)
    /// Admin: clubs awaiting verification (same row shape as join requests).
    func fetchPendingClubs(page: Int, size: Int) async throws(APIError) -> JoinRequestPage<ClubJoinRequestDTO>
    func setClubVerification(clubId: Int, accept: Bool, rejectionReason: String?) async throws(APIError)
}

/// Live network source for the join-request endpoints. Decodes the Spring
/// `Page<T>` shape directly (the API does not wrap it in `BaseResponse`).
final class JoinRequestDataSourceImpl: NetworkService<NotificationEndPoint>, JoinRequestDataSource {

    func fetchClubRequests(page: Int, size: Int) async throws(APIError) -> JoinRequestPage<ClubJoinRequestDTO> {
        try await fetch(endPoint: .clubJoinRequests(query(page: page, size: size)))
    }

    func fetchHangoutRequests(page: Int, size: Int) async throws(APIError) -> JoinRequestPage<HangoutJoinRequestDTO> {
        try await fetch(endPoint: .hangoutJoinRequests(query(page: page, size: size)))
    }

    func fetchEventRequests(page: Int, size: Int) async throws(APIError) -> JoinRequestPage<EventJoinRequestDTO> {
        try await fetch(endPoint: .eventJoinRequests(query(page: page, size: size)))
    }

    func setClubStatus(clubId: Int, userId: String, accept: Bool) async throws(APIError) {
        _ = try await fetchRawData(
            endPoint: .setClubRequestStatus(
                ClubRequestStatusBody(
                    clubId: clubId,
                    userId: userId,
                    status: accept ? "ACCEPT" : "REJECT"
                )
            )
        )
    }

    func setHangoutStatus(hangoutId: String, userId: String, accept: Bool) async throws(APIError) {
        _ = try await fetchRawData(
            endPoint: .setHangoutRequestStatus(
                hangoutId: hangoutId,
                body: HangoutRequestStatusBody(
                    userId: userId,
                    status: accept ? "ACCEPTED" : "REJECTED"
                )
            )
        )
    }

    func setEventStatus(eventId: String, userId: String, accept: Bool) async throws(APIError) {
        _ = try await fetchRawData(
            endPoint: .setEventRequestStatus(
                eventId: eventId,
                body: EventRequestStatusBody(
                    userId: userId,
                    status: accept ? "ACCEPTED" : "REJECTED"
                )
            )
        )
    }

    func fetchPendingClubs(page: Int, size: Int) async throws(APIError) -> JoinRequestPage<ClubJoinRequestDTO> {
        try await fetch(endPoint: .clubPending(query(page: page, size: size)))
    }

    func setClubVerification(clubId: Int, accept: Bool, rejectionReason: String?) async throws(APIError) {
        _ = try await fetchRawData(
            endPoint: .setClubVerification(
                ClubVerificationStatusBody(
                    clubId: clubId,
                    status: accept ? "ACCEPT" : "REJECT",
                    rejectionReason: accept ? nil : rejectionReason
                )
            )
        )
    }

    private func query(page: Int, size: Int) -> [String: String] {
        ["page": "\(page)", "size": "\(size)"]
    }
}
