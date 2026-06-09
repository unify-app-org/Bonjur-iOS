//
//  EventDetailDTO.swift
//  EventsImpl
//
//  Created by Codex on 10.06.26.
//

import Foundation
import AppPresentationModel

/// `GET api/es/v1/events/{eventId}`
struct EventDetailDTO: Decodable {
    let id: String?
    let visibility: AppPresentationModel.AccessType?
    let name: String?
    let ownerContact: String?
    let location: String?
    let about: String?
    let rule: String?
    let capacity: Int?
    let club: Club?
    let backgroundUrl: String?
    let membersCount: Int?
    let eventUserRole: AppPresentationModel.UserActivityRole?
    let attachments: [String]?
    let links: [Link]?
    let categories: [Category]?
    let isDeleted: Bool?
    let modifiedAt: String?

    struct Club: Decodable {
        let id: Int?
        let name: String?
    }

    struct Link: Decodable {
        let type: String?
        let name: String?
        let url: String?
    }

    struct Category: Decodable {
        let id: Int?
        let title: String?
    }
}

/// `GET api/es/v1/events/{eventId}/members` (paginated)
struct EventMembersResponse: Decodable {
    let content: [Member]
    let page: Int?
    let size: Int?
    let totalElements: Int?
    let numberOfElements: Int?
    let totalPages: Int?

    struct Member: Decodable {
        let userId: String?
        let profileUrl: String?
        let role: AppPresentationModel.UserActivityRole?
        let fullName: String?
        let degree: String?
        let specialization: String?
        let entryYear: Int?
    }
}
