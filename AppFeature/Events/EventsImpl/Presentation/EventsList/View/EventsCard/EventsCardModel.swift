//
//  EventsCardModel.swift
//  AppCore
//
//  Created by Huseyn Hasanov on 16.01.26.
//

import SwiftUICore
import AppUIKit
import Events
import AppPresentationModel

extension EventsCardView {
    
    struct Model: Identifiable {
        public let uuid: UUID = UUID()
        public let id: String
        let name: String
        let coverimageURL: String?
        let memberCount: Int
        let totalCapacity: Int?
        let club: Club
        let tags: [AppUIEntities.Tags]
        let bgType: AppUIEntities.BackgroundType
        let requestType: AppUIEntities.RequestType
        let accessType: AppUIEntities.AccessType
        
        init(
            id: String,
            name: String,
            coverimageURL: String?,
            memberCount: Int,
            totalCapacity: Int?,
            club: Club,
            tags: [AppUIEntities.Tags],
            bgType: AppUIEntities.BackgroundType,
            requestType: AppUIEntities.RequestType,
            accessType: AppUIEntities.AccessType
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
        
        var buttonTitle: String {
            switch requestType {
            case .joined:
                return ""
            case .rejected:
                return "Rejected"
            case .pending:
                return "Request sent"
            case .none:
                switch accessType {
                case .public:
                    return "Join"
                case .private:
                    return "Request"
                }
            }
        }
        
        var memberCountText: String {
            if let totalCapacity {
                return "\(memberCount)/\(totalCapacity) members"
            } else {
                return "\(memberCount) members"
            }
        }
    }
    
    struct Club {
        let name: String
        let id: Int
    }
}

extension EventsCardView.Model {
    
    init(from: EventsModuleModel.CardInputData) {
        self.init(
            id: from.id,
            name: from.name,
            coverimageURL: from.coverimageURL,
            memberCount: from.memberCount,
            totalCapacity: from.totalCapacity,
            club: .init(
                name: from.club.name,
                id: from.club.id
            ),
            tags: Self.mapTags(from.tags),
            bgType: Self.mapBackgroundType(from.bgType),
            requestType: Self.mapRequestType(from.requestType),
            accessType: Self.mapAccessType(from.accessType)
        )
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
    
    private static func mapTags(
        _ tags: [AppPresentationModel.Tags]
    ) -> [AppUIEntities.Tags] {
        tags.map {
            AppUIEntities.Tags(
                id: $0.id,
                type: $0.type,
                title: $0.title
            )
        }
    }
}


extension EventsCardView.Model {
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
