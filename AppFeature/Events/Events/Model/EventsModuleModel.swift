//
//  EventsModuleModel.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 21.01.26.
//

import Foundation
import AppPresentationModel

public enum EventsModuleModel {

    public struct CreatePrefillData {
        public let clubId: Int
        public let visibility: AppPresentationModel.AccessType
        public let name: String
        public let ownerContact: String
        public let about: String
        public let categories: [Category]
        public let location: String
        public let eventDate: Date
        public let reminder: String
        public let capacity: String
        public let links: [Link]
        public let attachments: [Attachment]
        public let rules: String

        public init(
            clubId: Int,
            visibility: AppPresentationModel.AccessType,
            name: String,
            ownerContact: String,
            about: String,
            categories: [Category],
            location: String,
            eventDate: Date,
            reminder: String,
            capacity: String,
            links: [Link],
            attachments: [Attachment],
            rules: String
        ) {
            self.clubId = clubId
            self.visibility = visibility
            self.name = name
            self.ownerContact = ownerContact
            self.about = about
            self.categories = categories
            self.location = location
            self.eventDate = eventDate
            self.reminder = reminder
            self.capacity = capacity
            self.links = links
            self.attachments = attachments
            self.rules = rules
        }
    }

    public struct Category {
        public let id: Int
        public let title: String

        public init(id: Int, title: String) {
            self.id = id
            self.title = title
        }
    }

    public struct Link {
        public let type: String
        public let name: String
        public let url: String

        public init(type: String, name: String, url: String) {
            self.type = type
            self.name = name
            self.url = url
        }
    }

    public struct Attachment {
        public let name: String
        public let url: URL
        public let size: String

        public init(name: String, url: URL, size: String) {
            self.name = name
            self.url = url
            self.size = size
        }
    }

    public struct CardInputData: Identifiable {
        public let uuid: UUID = UUID()
        public let id: String
        public let name: String
        public let coverimageURL: String?
        public let memberCount: Int
        public let totalCapacity: Int?
        public let club: Club
        public let tags: [AppPresentationModel.Tags]
        public let bgType: AppPresentationModel.BackgroundType
        public let requestType: AppPresentationModel.RequestType
        public let accessType: AppPresentationModel.AccessType
        public let role: AppPresentationModel.UserActivityRole
        public let location: String
        public let eventDate: Date?

        public init(
            id: String,
            name: String,
            coverimageURL: String?,
            memberCount: Int,
            totalCapacity: Int?,
            club: Club,
            tags: [AppPresentationModel.Tags],
            bgType: AppPresentationModel.BackgroundType,
            requestType: AppPresentationModel.RequestType,
            accessType: AppPresentationModel.AccessType,
            role: AppPresentationModel.UserActivityRole,
            location: String,
            eventDate: Date
        ) {
            self.id = id
            self.name = name
            self.coverimageURL = coverimageURL
            self.memberCount = memberCount
            self.totalCapacity = totalCapacity
            self.club = club
            self.tags = tags
            self.bgType = bgType
            self.requestType = requestType
            self.accessType = accessType
            self.role = role
            self.location = location
            self.eventDate = eventDate
        }
        
        public struct Club {
            public let name: String
            public let id: Int

            public init(name: String, id: Int) {
                self.name = name
                self.id = id
            }
        }
    }
}

public extension EventsModuleModel.CardInputData {
    static let previewMock: [Self] = [
        .init(
            id: UUID().uuidString,
            name: "Fan events",
            coverimageURL: "https://upload.wikimedia.org/wikipedia/commons/6/6a/JavaScript-logo.png",
            memberCount: 21,
            totalCapacity: 40,
            club: .init(
                name: "Football club",
                id: 2
            ),
            tags: [
                .init(
                    id: 1,
                    type: "SPORT",
                    title: "Football"
                ),
                .init(
                    id: 1,
                    type: "SPORT",
                    title: "Voleyball"
                ),
                .init(
                    id: 1,
                    type: "SPORT",
                    title: "Basketball"
                )
            ],
            bgType: .primary,
            requestType: .none,
            accessType: .public,
            role: .eventCreator,
            location: "Campus, Room 204",
            eventDate: Date()
        ),
        .init(
            id: UUID().uuidString,
            name: "Messi events",
            coverimageURL: "https://upload.wikimedia.org/wikipedia/commons/6/6a/JavaScript-logo.png",
            memberCount: 15,
            totalCapacity: 34,
            club: .init(
                name: "Football club",
                id: 2
            ),
            tags: [
                .init(
                    id: 1,
                    type: "SPORT",
                    title: "Football"
                ),
                .init(
                    id: 1,
                    type: "SPORT",
                    title: "Voleyball"
                ),
                .init(
                    id: 1,
                    type: "SPORT",
                    title: "Basketball"
                )
            ],
            bgType: .secondary,
            requestType: .none,
            accessType: .private,
            role: .notJoined,
            location: "Campus, Room 204",
            eventDate: Date()
        ),
        .init(
            id: UUID().uuidString,
            name: "Chess events",
            coverimageURL: "https://upload.wikimedia.org/wikipedia/commons/6/6a/JavaScript-logo.png",
            memberCount: 15,
            totalCapacity: 34,
            club: .init(
                name: "Chess club",
                id: 2
            ),
            tags: [
                .init(
                    id: 1,
                    type: "SPORT",
                    title: "Chess"
                ),
                .init(
                    id: 1,
                    type: "SPORT",
                    title: "Voleyball"
                ),
                .init(
                    id: 1,
                    type: "SPORT",
                    title: "Basketball"
                )
            ],
            bgType: .teritary,
            requestType: .pending,
            accessType: .public,
            role: .president,
            location: "Campus, Room 204",
            eventDate: Date()
        )
    ]
}
