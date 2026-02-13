//
//  CommunityCardModel.swift
//  AppCore
//
//  Created by Huseyn Hasanov on 16.01.26.
//

import SwiftUI
import AppUIKit
import Communities
import AppPresentationModel

extension CommunityCardView {
    
    struct Model: Identifiable {
        let uuid: UUID = UUID()
        let id: Int
        let name: String
        let subTitle: String
        let logoURL: String
        let memberCount: Int
        let type: AppUIEntities.ActivityType = .community
        let members: [AppUIEntities.Member]
        let bgType: AppUIEntities.BackgroundType
        
        init(
            id: Int,
            name: String,
            subTitle: String,
            logoURL: String,
            memberCount: Int,
            members: [AppUIEntities.Member],
            bgType: AppUIEntities.BackgroundType
        ) {
            self.id = id
            self.subTitle = subTitle
            self.name = name
            self.logoURL = logoURL
            self.memberCount = memberCount
            self.members = members
            self.bgType = bgType
        }
    }
}

extension CommunityCardView.Model {
    init(from: CommunitiesModuleModel.CardInputData) {
        self.init(
            id: from.id,
            name: from.name,
            subTitle: from.subTitle,
            logoURL: from.logoURL,
            memberCount: from.memberCount,
            members: Self.mapMembers(from.members),
            bgType: Self.mapBackgroundType(from.bgType)
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
}

extension CommunityCardView.Model {
    static let mock: [Self] = [
        .init(
            id: 1,
            name: "UFAZ",
            subTitle: "Community",
            logoURL: "https://upload.wikimedia.org/wikipedia/commons/6/6a/JavaScript-logo.png",
            memberCount: 123,
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
            bgType: .secondary
        ),
        .init(
            id: 1,
            name: "Unify",
            subTitle: "Community",
            logoURL: "https://upload.wikimedia.org/wikipedia/commons/6/6a/JavaScript-logo.png",
            memberCount: 1675,
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
            bgType: .primary
        )
    ]
}
