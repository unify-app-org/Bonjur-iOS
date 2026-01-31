//
//  ClubsDetailsModel.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 31.01.26.
//

import AppUIKit
import Events
import Foundation

struct ClubsDetailsModel {
    
    struct UIModel {
        let name: String
        let communityName: String
        let membersCount: Int
        let logo: URL?
        let coverImage: URL?
        let coverColorType: AppUIEntities.BackgroundType
        let userActivityType: AppUIEntities.UserActivityRole
        let accessType: AppUIEntities.AccessType
        let tags: [AppUIEntities.Tags]
        let infoData: [Info]
        let eventsData: [EventsModuleModel.CardInputData]
    }
    
    struct Info: Identifiable {
        let id = UUID()
        let title: String
        let subItems: [SubInfo]
    }
    
    struct SubInfo: Identifiable {
        let id = UUID()
        let title: String?
        let description: String
        let isLink: Bool
        
        init(
            title: String?,
            description: String,
            isLink: Bool = false
        ) {
            self.title = title
            self.isLink = isLink
            self.description = description
        }
    }
}

extension ClubsDetailsModel.UIModel {
    static let mockData: Self = .init(
        name: "Football Club",
        communityName: "UFAZ community",
        membersCount: 12,
        logo: nil,
        coverImage: nil,
        coverColorType: .secondary,
        userActivityType: .notJoined,
        accessType: .private,
        tags: [
            .init(id: 1, type: "SPORT", title: "Messi"),
            .init(id: 1, type: "SPORT", title: "Ronaldo lox"),
            .init(id: 1, type: "SPORT", title: "Ronaldinho"),
            .init(id: 1, type: "SPORT", title: "Basketball")
        ],
        infoData: [
            .init(
                title: "About",
                subItems: [
                    .init(
                        title: nil,
                        description: "I want to have a coffee and then go to the film I have one free ticket to the concert for the Sunday evening if someone want just contact."
                    )
                ]
            ),
            .init(
                title: "Event info",
                subItems: [
                    .init(
                        title: "Created/Updated Data",
                        description: "30 noyabr 2025"
                    ),
                    .init(
                        title: "Owner contact",
                        description: "+994 123 45 67"
                    ),
                    .init(
                        title: "Capacity",
                        description: "161/200 members"
                    ),
                    .init(
                        title: "Rules",
                        description: "Everyone can come"
                    ),
                    .init(
                        title: "Location",
                        description: "Cafetaria, 2nd floor"
                    )
                ]
            ),
            .init(
                title: "Link",
                subItems: [
                    .init(
                        title: "Whatsapp Link",
                        description: "https://www.ufaz.az/en",
                        isLink: true
                    ),
                    .init(
                        title: "Telegram link",
                        description: "https://www.ufaz.az/en",
                        isLink: true
                    )
                ]
            )
        ],
        eventsData: EventsModuleModel.CardInputData.previewMock
    )
}
