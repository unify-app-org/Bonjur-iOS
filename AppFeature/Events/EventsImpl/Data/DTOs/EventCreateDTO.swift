//
//  EventCreateDTO.swift
//  EventsImpl
//
//  Created by Codex on 08.06.26.
//

import Foundation
import AppPresentationModel

struct ClubForEventDTO: Decodable {
    let communityName: String?
    let requestStatus: AppPresentationModel.RequestType?
    let count, id: Int
    let backgroundUrl, clubProfile: String?
    let visibility: AppPresentationModel.AccessType?
    let role: AppPresentationModel.UserActivityRole?
    let background: AppPresentationModel.BackgroundType?
    let name: String?
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

struct EventCreateRequest: Encodable {
    let clubId: Int
    let name: String
    let about: String
    let location: String
    let ownerContact: String
    let capacity: Int?
    let rule: String?
    let visibility: String
    let eventDate: String
    let reminderTimes: [String]
    let categoryIds: [Int]
    let links: [Link]
    let userIds: [String]

    struct Link: Encodable {
        let type: String
        let name: String
        let url: String
    }
}
