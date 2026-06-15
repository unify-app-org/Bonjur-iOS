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
    let location, eventDate: String?
    let about: String?
    let rule: String?
    let capacity: Int?
    let club: Club?
    let backgroundUrl: String?
    let membersCount: Int?
    let eventUserRole: AppPresentationModel.UserActivityRole?
    let attachments: [Attachments]?
    let links: [Link]?
    let categories: [Category]?
    let isDeleted: Bool?
    let modifiedAt: String?
    let reminderTimes: [AppPresentationModel.ReminderOption]?

    struct Attachments: Decodable {
        let url: String?
        let name: String?
        let size: String?
    }
    
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

/// `GET api/ds/v1/events` (discover feed, returns a JSON array)
struct EventDiscoverDTO: Decodable {
    let id: String?
    let name: String?
    let visibility: AppPresentationModel.AccessType?
    let about: String?
    let location: String?
    let eventDate: String?
    let capacity: Int?
    let membersCount: Int?
    let background: String?
    let club: EventDetailDTO.Club?
    let requestStatus: AppPresentationModel.RequestType?
    let eventActivityStatus: AppPresentationModel.ActivityStatus?
    let role: AppPresentationModel.UserActivityRole?
    let categoryResponses: [EventDetailDTO.Category]
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
