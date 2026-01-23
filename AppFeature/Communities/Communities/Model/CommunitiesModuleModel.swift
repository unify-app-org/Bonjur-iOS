//
//  CommunitiesModuleModel.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 23.01.26.
//

import Foundation
import AppPresentationModel

public enum CommunitiesModuleModel {
    
    public struct CardInputData: Identifiable {
        public let uuid: UUID = UUID()
        public let id: Int
        public let name: String
        public let subTitle: String
        public let logoURL: String
        public let memberCount: Int
        public let type: AppPresentationModel.ActivityType = .community
        public let members: [AppPresentationModel.Member]
        public let bgType: AppPresentationModel.BackgroundType
        
        public init(
            id: Int,
            name: String,
            subTitle: String,
            logoURL: String,
            memberCount: Int,
            members: [AppPresentationModel.Member],
            bgType: AppPresentationModel.BackgroundType
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


public extension CommunitiesModuleModel.CardInputData {
    static let previewMock: [Self] = [
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
