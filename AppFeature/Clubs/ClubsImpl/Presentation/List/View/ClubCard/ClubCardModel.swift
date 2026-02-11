//
//  ClubCardModel.swift
//  AppCore
//
//  Created by Huseyn Hasanov on 16.01.26.
//

import Foundation
import AppUIKit
import Clubs
import AppPresentationModel

extension ClubCardView {
    
    struct Model: Identifiable {
        let uuid: UUID = UUID()
        let id: Int
        let name, communityName: String
        let logoURL: String
        let memberCount, totalCapacity: Int
        let community: String
        let type: AppUIEntities.ActivityType = .clubs
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

extension ClubCardView.Model {

    init(from model: ClubsModuleModel.CardInputData) {
        self.init(
            id: model.id,
            name: model.name,
            communityName: model.communityName,
            logoURL: model.logoURL,
            memberCount: model.memberCount,
            totalCapacity: model.totalCapacity,
            community: model.community,
            members: Self.mapMembers(model.members),
            bgType: Self.mapBackgroundType(model.bgType),
            accessType: Self.mapAccessType(model.accessType),
            requestType: Self.mapRequestType(model.requestType)
        )
    }
    
    private static func mapMembers(
        _ members: [AppPresentationModel.Member]
    ) -> [AppUIEntities.Member] {
        members.map {
            AppUIEntities.Member(
                id: $0.id,
                profileImage: $0.profileImage
            )
        }
    }
    
    private static func mapColorType(
        _ type: AppPresentationModel.ColorType
    ) -> AppUIEntities.ColorType {
        switch type {
        case .orange:
            return .orange
        case .red:
            return .red
        case .pink:
            return .pink
        }
    }
    
    private static func mapBackgroundType(
        _ type: AppPresentationModel.BackgroundType
    ) -> AppUIEntities.BackgroundType {
        switch type {
        case .primary:
            return .primary
        case .secondary:
            return .secondary
        case .teritary:
            return .teritary
        case .color(let color):
            return .color(mapColorType(color))
        }
    }
    
    private static func mapRequestType(
        _ type: AppPresentationModel.RequestType
    ) -> AppUIEntities.RequestType {
        switch type {
        case .joined:
            return .joined
        case .rejected:
            return .rejected
        case .pending:
            return .pending
        case .none:
            return .none
        }
    }
    
    private static func mapAccessType(
        _ type: AppPresentationModel.AccessType
    ) -> AppUIEntities.AccessType {
        switch type {
        case .public:
            return .public
        case .private:
            return .private
        }
    }
}


extension ClubCardView.Model {
    static let previewData: [Self] = [
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
