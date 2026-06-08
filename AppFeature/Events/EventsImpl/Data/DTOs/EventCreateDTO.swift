//
//  EventCreateDTO.swift
//  EventsImpl
//
//  Created by Codex on 08.06.26.
//

import Foundation

/// Club the user can create an event under. `GET api/cs/v1/clubs/forEvents`.
struct ClubForEventDTO: Decodable {
    let clubId: Int
    let clubName: String?
    let profileUrl: String?
}

/// Category group. `GET api/sd/v1/categories` (shared with clubs).
struct EventCategoriesResponse: Decodable {
    let type: String?
    let title: String?
    let subCategories: [EventSubCategoriesResponse]
}

struct EventSubCategoriesResponse: Decodable {
    let id: Int?
    let title: String?
}
