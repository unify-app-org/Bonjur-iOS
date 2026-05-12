//
//  HangoutsCardModel.swift
//  AppCore
//
//  Created by Huseyn Hasanov on 16.01.26.
//

import Foundation
import AppUIKit
import Hangouts

extension HangoutsCardView {
    
    struct Model: Identifiable {
        public let uuid: UUID = UUID()
        public let id: String
        let name, description: String
        let memberCount: Int
        let totalCapacity: Int?
        let tags: [AppUIEntities.Tags]
        let accessType: AppUIEntities.AccessType
        let requestType: AppUIEntities.RequestType
        
        init(
            id: String,
            name: String,
            description: String,
            memberCount: Int,
            totalCapacity: Int?,
            tags: [AppUIEntities.Tags],
            accessType: AppUIEntities.AccessType,
            requestType: AppUIEntities.RequestType
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
        
        var memberCountText: String {
            if let totalCapacity {
                return "\(memberCount)/\(totalCapacity) members"
            } else {
                return "\(memberCount) members"
            }
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
    }
}

extension HangoutsCardView.Model {
    init(from: HangoutsModuleModel.CardInputData) {
        self.init(
            id: from.id,
            name: from.name,
            description: from.description,
            memberCount: from.memberCount,
            totalCapacity: from.totalCapacity,
            tags: from.tags,
            accessType: from.accessType,
            requestType: from.requestType
        )
    }
}

extension HangoutsCardView.Model {
    
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
