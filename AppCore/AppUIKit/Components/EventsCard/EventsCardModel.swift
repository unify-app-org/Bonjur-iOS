//
//  EventsCardModel.swift
//  AppCore
//
//  Created by Huseyn Hasanov on 16.01.26.
//

import SwiftUICore

public extension EventsCardView {
    
    struct Model: Identifiable {
        public let uuid: UUID = UUID()
        public let id: String
        let name: String
        let coverimageURL: String?
        let memberCount: Int
        let totalCapacity: Int?
        let club: Club
        let tags: [Tags]
        let bgType: AppUIEntities.BackgroundType
        let requestType: AppUIEntities.RequestType
        let accessType: AppUIEntities.AccessType
        
        public init(
            id: String,
            name: String,
            coverimageURL: String?,
            memberCount: Int,
            totalCapacity: Int?,
            club: Club,
            tags: [Tags],
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
    
    struct Tags: Identifiable {
        public let uuid: UUID = UUID()
        public let id: Int
        public let type: String
        let title: String
        
        init(
            id: Int,
            type: String,
            title: String
        ) {
            self.id = id
            self.type = type
            self.title = title
        }
    }
}


extension EventsCardView.Model {
    static let mock: Self = .init(
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
    )
}
