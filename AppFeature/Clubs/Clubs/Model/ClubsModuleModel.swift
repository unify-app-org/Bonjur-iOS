//
//  ClubsModuleModel.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 20.01.26.
//

import Foundation
import AppPresentationModel

public struct ClubsModuleModel {
    
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
