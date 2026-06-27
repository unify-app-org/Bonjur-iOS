//
//  CommunityDetails.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 03.02.26.
//

import AppUIKit
import Events
import Clubs
import Foundation

struct CommunityDetails {
    
    struct UIModel {
        let name: String
        let membersCount: Int
        let clubsCount: Int?
        let eventsCount: Int?
        let logo: URL?
        let coverImage: URL?
        let coverColorType: AppUIEntities.BackgroundType
        let userActivity: AppUIEntities.UserActivityRole
        let tags: [AppUIEntities.Tags]
        let infoData: [Info]
        let editPrefillData: ClubsModuleModel.CreatePrefillData
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
        /// When set, the row is tappable and offers Call/Copy for this phone number.
        let phoneNumber: String?

        init(
            title: String?,
            description: String,
            isLink: Bool = false,
            phoneNumber: String? = nil
        ) {
            self.title = title
            self.isLink = isLink
            self.description = description
            self.phoneNumber = phoneNumber
        }
    }
}

extension CommunityDetails.UIModel {
    static let mockData: Self = .init(
        name: "UFAZ Community",
        membersCount: 12,
        clubsCount: 1,
        eventsCount: 12,
        logo: nil,
        coverImage: nil,
        coverColorType: .secondary,
        userActivity: .member,
        tags: [
            .init(id: 1, type: "SPORT", title: "Messi"),
            .init(id: 1, type: "SPORT", title: "Ronaldo"),
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
        editPrefillData: .init(
            logoURL: nil,
            coverURL: nil,
            coverType: .secondary,
            visibility: .private,
            name: "UFAZ Community",
            ownerContact: "+994 123 45 67",
            categories: [
                .init(id: 1, title: "Messi"),
                .init(id: 2, title: "Ronaldo")
            ],
            capacity: "200",
            links: [
                .init(type: "", name: "Whatsapp Link", url: "https://www.ufaz.az/en"),
                .init(type: "", name: "Telegram link", url: "https://www.ufaz.az/en")
            ],
            location: "Cafetaria, 2nd floor",
            rules: "Everyone can come",
            about: "I want to have a coffee and then go to the film I have one free ticket to the concert for the Sunday evening if someone want just contact."
        )
    )
}
