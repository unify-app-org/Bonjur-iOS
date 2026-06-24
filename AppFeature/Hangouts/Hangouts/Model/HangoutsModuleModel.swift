//
//  HangoutsModuleModel.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 21.01.26.
//

import Foundation
import AppPresentationModel

public enum HangoutsModuleModel {
    
    public struct CreatePrefillData {
        public let visibility: AppPresentationModel.AccessType
        public let name: String
        public let ownerContact: String
        public let clubName: String
        public let clubOwnerContact: String
        public let categories: [Category]
        public let capacity: String
        public let links: [Link]
        public let rules: String
        public let location: String
        public let about: String
        public let hangoutDate: Date?
        public let endDate: Date?
        
        public init(
            visibility: AppPresentationModel.AccessType,
            name: String,
            ownerContact: String,
            clubName: String,
            clubOwnerContact: String,
            categories: [Category],
            capacity: String,
            links: [Link],
            rules: String,
            location: String,
            about: String,
            hangoutDate: Date?,
            endDate: Date?
        ) {
            self.visibility = visibility
            self.name = name
            self.ownerContact = ownerContact
            self.clubName = clubName
            self.clubOwnerContact = clubOwnerContact
            self.categories = categories
            self.capacity = capacity
            self.links = links
            self.rules = rules
            self.location = location
            self.about = about
            self.hangoutDate = hangoutDate
            self.endDate = endDate
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
    
    public struct CardInputData: Identifiable {
        public let uuid: UUID = UUID()
        public let id: String
        public let name, description: String
        public let memberCount: Int
        public let totalCapacity: Int?
        public let tags: [AppPresentationModel.Tags]
        public let accessType: AppPresentationModel.AccessType
        public let requestType: AppPresentationModel.RequestType
        public let location: String?
        public let hangoutDate: Date?
        public let role: AppPresentationModel.UserActivityRole?

        public init(
            id: String,
            name: String,
            description: String,
            memberCount: Int,
            totalCapacity: Int?,
            tags: [AppPresentationModel.Tags],
            accessType: AppPresentationModel.AccessType,
            requestType: AppPresentationModel.RequestType,
            location: String? = nil,
            hangoutDate: Date? = nil,
            role: AppPresentationModel.UserActivityRole? = nil
        ) {
            self.id = id
            self.name = name
            self.description = description
            self.memberCount = memberCount
            self.totalCapacity = totalCapacity
            self.tags = tags
            self.accessType = accessType
            self.requestType = requestType
            self.location = location
            self.hangoutDate = hangoutDate
            self.role = role
        }
    }
}

public extension HangoutsModuleModel.CardInputData {
    
    static let previewMock: [Self] = [
        .init(
            id: UUID().uuidString,
            name: "Study night at cafe",
            description: "I want to have a coffee and then go to evening if someone want just",
            memberCount: 27,
            totalCapacity: 35,
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
            accessType: .public,
            requestType: .none
        ),
        .init(
            id: UUID().uuidString,
            name: "Exam preparation",
            description: "I want to have a coffee and then go to evening if someone want just",
            memberCount: 27,
            totalCapacity: 35,
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
            accessType: .public,
            requestType: .none
        ),
        .init(
            id: UUID().uuidString,
            name: "To find new peoples",
            description: "I want to have a coffee and then go to evening if someone want just",
            memberCount: 27,
            totalCapacity: 35,
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
            accessType: .public,
            requestType: .none
        )
    ]
}
