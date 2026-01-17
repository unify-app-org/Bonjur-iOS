//
//  ClubCardModel.swift
//  AppCore
//
//  Created by Huseyn Hasanov on 16.01.26.
//

import Foundation

public extension ClubCardView {
    
    struct Model: Identifiable {
        public let uuid: UUID = UUID()
        public let id: Int
        let name, communityName: String
        let logoURL: String
        let memberCount, totalCapacity: Int
        let community: String
        public let type: AppUIEntities.ActivityType = .clubs
        let members: [AppUIEntities.Member]
        let bgType: AppUIEntities.BackgroundType
        let accessType: AppUIEntities.AccessType
        let requestType: AppUIEntities.RequestType
        
        public init(
            id: Int,
            name: String,
            communityName: String,
            logoURL: String,
            memberCount: Int,
            totalCapacity: Int,
            community: String,
            members: [AppUIEntities.Member],
            bgType: AppUIEntities.BackgroundType,
            accessType: AppUIEntities.AccessType,
            requestType: AppUIEntities.RequestType,
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
        }
    }
}

public extension ClubCardView.Model {
    static let mock: [Self] = [
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
                    id: 1,
                    profileImage: "https://upload.wikimedia.org/wikipedia/commons/a/a7/React-icon.svg"
                ),
                .init(
                    id: 2,
                    profileImage: "https://upload.wikimedia.org/wikipedia/commons/6/6a/JavaScript-logo.png"
                ),
                .init(
                    id: 3,
                    profileImage: "https://upload.wikimedia.org/wikipedia/commons/6/6a/JavaScript-logo.png"
                )
            ],
            bgType: .color(.orange),
            accessType: .private,
            requestType: .none
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
                    id: 1,
                    profileImage: nil
                ),
                .init(
                    id: 2,
                    profileImage: "https://upload.wikimedia.org/wikipedia/commons/6/6a/JavaScript-logo.png"
                ),
                .init(
                    id: 3,
                    profileImage: "https://upload.wikimedia.org/wikipedia/commons/6/6a/JavaScript-logo.png"
                )
            ],
            bgType: .primary,
            accessType: .public,
            requestType: .pending
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
                    id: 1,
                    profileImage: nil
                ),
                .init(
                    id: 2,
                    profileImage: "https://upload.wikimedia.org/wikipedia/commons/6/6a/JavaScript-logo.png"
                ),
                .init(
                    id: 3,
                    profileImage: "https://upload.wikimedia.org/wikipedia/commons/6/6a/JavaScript-logo.png"
                )
            ],
            bgType: .secondary,
            accessType: .private,
            requestType: .none
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
                    id: 1,
                    profileImage: nil
                ),
                .init(
                    id: 2,
                    profileImage: "https://upload.wikimedia.org/wikipedia/commons/6/6a/JavaScript-logo.png"
                ),
                .init(
                    id: 3,
                    profileImage: "https://upload.wikimedia.org/wikipedia/commons/6/6a/JavaScript-logo.png"
                )
            ],
            bgType: .color(.red),
            accessType: .private,
            requestType: .none
        )
    ]
}
