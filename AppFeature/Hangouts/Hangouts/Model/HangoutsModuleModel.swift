//
//  HangoutsModuleModel.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 21.01.26.
//

import Foundation
import AppPresentationModel

public enum HangoutsModuleModel {
    
    public struct CardInputData: Identifiable {
        public let uuid: UUID = UUID()
        public let id: String
        public let name, description: String
        public let memberCount: Int
        public let totalCapacity: Int?
        public let tags: [AppPresentationModel.Tags]
        public let accessType: AppPresentationModel.AccessType
        public let requestType: AppPresentationModel.RequestType
        
        public init(
            id: String,
            name: String,
            description: String,
            memberCount: Int,
            totalCapacity: Int?,
            tags: [AppPresentationModel.Tags],
            accessType: AppPresentationModel.AccessType,
            requestType: AppPresentationModel.RequestType
        ) {
            self.id = id
            self.name = name
            self.description = description
            self.memberCount = memberCount
            self.totalCapacity = totalCapacity
            self.tags = tags
            self.accessType = accessType
            self.requestType = requestType
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
