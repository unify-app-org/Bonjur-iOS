//
//  ClubsModuleModel.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 20.01.26.
//

import Foundation
import AppPresentationModel

public struct ClubsModuleModel {
    
    public struct CreatePrefillData {
        public let logoURL: URL?
        public let coverURL: URL?
        public let coverType: AppPresentationModel.BackgroundType
        public let visibility: AppPresentationModel.AccessType
        public let name: String
        public let ownerContact: String
        public let categories: [Category]
        public let capacity: String
        public let links: [Link]
        public let location: String
        public let rules: String
        public let about: String
        
        public init(
            logoURL: URL?,
            coverURL: URL?,
            coverType: AppPresentationModel.BackgroundType,
            visibility: AppPresentationModel.AccessType,
            name: String,
            ownerContact: String,
            categories: [Category],
            capacity: String,
            links: [Link],
            location: String,
            rules: String,
            about: String
        ) {
            self.logoURL = logoURL
            self.coverURL = coverURL
            self.coverType = coverType
            self.visibility = visibility
            self.name = name
            self.ownerContact = ownerContact
            self.categories = categories
            self.capacity = capacity
            self.links = links
            self.location = location
            self.rules = rules
            self.about = about
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
        public let id: Int
        public let name, communityName: String
        public let logoURL: String
        public let memberCount, totalCapacity: Int
        public let community: String
        public let type: AppPresentationModel.ActivityType = .clubs
        public let members: [AppPresentationModel.Member]
        public let bgType: AppPresentationModel.BackgroundType
        public let accessType: AppPresentationModel.AccessType
        public let requestType: AppPresentationModel.RequestType
        public let role: AppPresentationModel.UserActivityRole?
        public let upcomingEventsCount: Int
        public let categories: [Category]
        public let isVerified: Bool

        public init(
            id: Int,
            name: String,
            communityName: String,
            logoURL: String,
            memberCount: Int,
            totalCapacity: Int,
            community: String,
            members: [AppPresentationModel.Member],
            bgType: AppPresentationModel.BackgroundType,
            accessType: AppPresentationModel.AccessType,
            requestType: AppPresentationModel.RequestType,
            role: AppPresentationModel.UserActivityRole,
            upcomingEventsCount: Int,
            categories: [Category],
            isVerified: Bool = false
        ) {
            self.id = id
            self.name = name
            self.communityName = communityName
            self.logoURL = logoURL
            self.memberCount = memberCount
            self.totalCapacity = totalCapacity
            self.members = members
            self.bgType = bgType
            self.accessType = accessType
            self.requestType = requestType
            self.community = community
            self.role = role
            self.upcomingEventsCount = upcomingEventsCount
            self.categories = categories
            self.isVerified = isVerified
        }
    }
}

public extension ClubsModuleModel.CardInputData {
    
    static let previewMock: [Self] = [
        .init(
            id: 1,
            name: "Football club",
            communityName: "Azerbaijany French university",
            logoURL: "https://upload.wikimedia.org/wikipedia/commons/6/6a/JavaScript-logo.png",
            memberCount: 190,
            totalCapacity: 200,
            community: "UFAZ",
            members: [
                .init(
                    id: "1",
                    profileImage: "https://upload.wikimedia.org/wikipedia/commons/a/a7/React-icon.svg"
                ),
                .init(
                    id: "2",
                    profileImage: "https://upload.wikimedia.org/wikipedia/commons/6/6a/JavaScript-logo.png"
                ),
                .init(
                    id: "3",
                    profileImage: "https://upload.wikimedia.org/wikipedia/commons/6/6a/JavaScript-logo.png"
                )
            ],
            bgType: .orange,
            accessType: .private,
            requestType: .none,
            role: .notJoined,
            upcomingEventsCount: 2,
            categories: [.init(id: 1, title: "Sport"), .init(id: 2, title: "Tournament")]
        ),
        .init(
            id: 1,
            name: "Dance club",
            communityName: "Azerbaijany French university",
            logoURL: "https://upload.wikimedia.org/wikipedia/commons/6/6a/JavaScript-logo.png",
            memberCount: 56,
            totalCapacity: 120,
            community: "UFAZ",
            members: [
                .init(
                    id: "1",
                    profileImage: nil
                ),
                .init(
                    id: "2",
                    profileImage: "https://upload.wikimedia.org/wikipedia/commons/6/6a/JavaScript-logo.png"
                ),
                .init(
                    id: "3",
                    profileImage: "https://upload.wikimedia.org/wikipedia/commons/6/6a/JavaScript-logo.png"
                )
            ],
            bgType: .primary,
            accessType: .public,
            requestType: .pending,
            role: .notJoined,
            upcomingEventsCount: 2,
            categories: [.init(id: 1, title: "Sport"), .init(id: 2, title: "Tournament")]
        ),
        .init(
            id: 1,
            name: "Boys club",
            communityName: "Azerbaijany French university",
            logoURL: "https://upload.wikimedia.org/wikipedia/commons/6/6a/JavaScript-logo.png",
            memberCount: 56,
            totalCapacity: 120,
            community: "UFAZ",
            members: [
                .init(
                    id: "1",
                    profileImage: nil
                ),
                .init(
                    id: "2",
                    profileImage: "https://upload.wikimedia.org/wikipedia/commons/6/6a/JavaScript-logo.png"
                ),
                .init(
                    id: "3",
                    profileImage: "https://upload.wikimedia.org/wikipedia/commons/6/6a/JavaScript-logo.png"
                )
            ],
            bgType: .secondary,
            accessType: .private,
            requestType: .none,
            role: .notJoined,
            upcomingEventsCount: 2,
            categories: [.init(id: 1, title: "Sport"), .init(id: 2, title: "Tournament")]
        ),
        .init(
            id: 1,
            name: "Girls club",
            communityName: "Azerbaijany French university",
            logoURL: "https://upload.wikimedia.org/wikipedia/commons/6/6a/JavaScript-logo.png",
            memberCount: 56,
            totalCapacity: 120,
            community: "UFAZ",
            members: [
                .init(
                    id: "1",
                    profileImage: nil
                ),
                .init(
                    id: "2",
                    profileImage: "https://upload.wikimedia.org/wikipedia/commons/6/6a/JavaScript-logo.png"
                ),
                .init(
                    id: "3",
                    profileImage: "https://upload.wikimedia.org/wikipedia/commons/6/6a/JavaScript-logo.png"
                )
            ],
            bgType: .red,
            accessType: .private,
            requestType: .none,
            role: .notJoined,
            upcomingEventsCount: 2,
            categories: [.init(id: 1, title: "Sport"), .init(id: 2, title: "Tournament")]
        )
    ]
}
