//
//  EventsModuleModel.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 21.01.26.
//

import Foundation
import AppPresentationModel

public enum EventsModuleModel {
    
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
            accessType: AppPresentationModel.AccessType
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
        }
        
        public struct Club {
            public let name: String
            public let id: Int
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
            accessType: .public
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
            accessType: .private
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
            accessType: .public
        )
    ]
}
