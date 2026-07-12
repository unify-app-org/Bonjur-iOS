//
//  JoinRequestDTO.swift
//  NotificationImpl
//
//  Created by Huseyn Hasanov on 28.06.26.
//

import Foundation

// MARK: - Page wrapper

/// Spring `Page<T>` shape returned by the join-request endpoints. Unwrapped
/// directly (the response is NOT a `BaseResponse` envelope — the page object is
/// the top level), so we decode this whole struct as the request's `T`.
struct JoinRequestPage<Item: Decodable>: Decodable {
    let content: [Item]
    let page: Int?
    let size: Int?
    let totalElements: Int?
    let numberOfElements: Int?
    let totalPages: Int?

    /// True when there are pages after `page` (load-more should fire).
    var hasMore: Bool {
        guard let page, let totalPages else { return false }
        return page + 1 < totalPages
    }
}

// MARK: - Club

/// `GET api/cs/v1/clubs/join-requests` content row.
/// `fileUrl` is the requester's profile photo (parallel to the hangout
/// endpoint's `userProfileUrl`).
struct ClubJoinRequestDTO: Decodable {
    let userId: String?
    let fullName: String?
    let clubId: Int?
    let clubName: String?
    let fileUrl: String?
    /// Added server-side after the initial spec; may be absent on old rows.
    let createdAt: String?
}

// MARK: - Hangout

/// `GET api/hs/v1/hangouts/join-requests` content row.
/// `userProfileUrl` is the requester photo; `fileUrl` is the hangout's image
/// (unused on the row — we show the requester).
struct HangoutJoinRequestDTO: Decodable {
    let userId: String?
    let userProfileUrl: String?
    let fullName: String?
    let fileUrl: String?
    let hangoutId: String?
    let hangoutName: String?
    let createdAt: String?
}

// MARK: - Event

/// `GET api/es/v1/events/requests` content row. The live API sends neither
/// `fileUrl` nor `createdAt` yet — both decoded optionally for when they ship
/// (rows sort last / show no time stamp meanwhile).
struct EventJoinRequestDTO: Decodable {
    let userId: String?
    let userProfileUrl: String?
    let fullName: String?
    let fileUrl: String?
    let eventId: String?
    let eventName: String?
    let createdAt: String?
}
