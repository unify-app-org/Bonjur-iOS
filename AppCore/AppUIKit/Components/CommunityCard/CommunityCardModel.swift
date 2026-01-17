//
//  CommunityCardModel.swift
//  AppCore
//
//  Created by Huseyn Hasanov on 16.01.26.
//

import SwiftUICore

public extension CommunityCardView {
    
    struct Model: Identifiable {
        public let uuid: UUID = UUID()
        public let id: Int
        let name: String
        let subTitle: String
        let logoURL: String
        let memberCount: Int
        public let type: AppUIEntities.ActivityType = .community
        let members: [AppUIEntities.Member]
        let bgType: AppUIEntities.BackgroundType
        
        public init(
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


public extension CommunityCardView.Model {
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
            name: "Bonjur",
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
