//
//  ClubsDetailsModel.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 31.01.26.
//

import AppUIKit
import Communities
import Events
import Foundation

struct ClubsDetailsModel {
    struct UIModel {
        let name: String
        let communityName: String
        let membersCount: Int
        let eventsCount: Int?
        let clubsCount: Int?
        let logo: URL?
        let coverImage: URL?
        let coverColorType: AppUIEntities.BackgroundType
        let userActivityType: AppUIEntities.UserActivityRole
        let accessType: AppUIEntities.AccessType
        let tags: [AppUIEntities.Tags]
        let infoData: [Info]
        let editPrefillData: ClubsCreate.PrefillData
        let joinButton: JoinButton?
        /// nil/unverified → request-verify button (admins); verified → badge.
        let clubStatus: AppUIEntities.ClubStatus?
    }

    struct JoinButton {
        let title: String
        let disabled: Bool
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

extension ClubsDetailsModel.UIModel {
    static let mockData: Self = .init(
        name: "Football Club",
        communityName: "UFAZ community",
        membersCount: 5,
        eventsCount: 3,
        clubsCount: 2,
        logo: nil,
        coverImage: nil,
        coverColorType: .secondary,
        userActivityType: .notJoined,
        accessType: .private,
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
                title: "Club info",
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
            values: [
                .cover: .cover(.secondary),
                .visibility: .radio(.private),
                .clubName: .text("Football Club"),
                .ownerContact: .text("+994 123 45 67"),
                .category: .tags([
                    .init(id: 1, label: "Messi"),
                    .init(id: 2, label: "Ronaldo")
                ]),
                .capacity: .text("200"),
                .links: .links([
                    .init(type: "", name: "Whatsapp Link", url: "https://www.ufaz.az/en"),
                    .init(type: "", name: "Telegram link", url: "https://www.ufaz.az/en")
                ]),
                .location: .text("Cafetaria, 2nd floor"),
                .rules: .text("Everyone can come"),
                .about: .text("I want to have a coffee and then go to the film I have one free ticket to the concert for the Sunday evening if someone want just contact.")
            ]
        ), joinButton: nil,
        clubStatus: .verified
    )
}

private extension CommunitiesMemberModuleModel.GroupedMembersData {
    static let mockData: Self = .init(
        users: [
            .init(
                id: "owner-1",
                name: "Nihad Asgarli",
                avatarURL: URL(string: "https://i.pinimg.com/736x/76/f7/d5/76f7d5c6bb02d8d142dd359b534e326e.jpg"),
                subtitle: "Bachelor, Computer engineering, 2017",
                role: .president
            ),
            .init(
                id: "president-1",
                name: "Huseyn Hasanov",
                avatarURL: URL(string: "https://i.pinimg.com/736x/ae/9e/cb/ae9ecb29d446fdf6679ee4bfd28280af.jpg"),
                subtitle: "Bachelor, Computer engineering, 2017",
                role: .visePresident
            ),
            .init(
                id: "member-1",
                name: "Durdana Hasanova",
                avatarURL: URL(string: "https://i.pinimg.com/736x/98/31/0d/98310da7fa99a746b088721b25903d4b.jpg"),
                subtitle: "Bachelor, Computer engineering, 2017"
            ),
            .init(
                id: "member-2",
                name: "Ayan Aliyeva",
                avatarURL: URL(string: "https://i.pinimg.com/736x/d7/60/93/d76093672c8baa3b56665ec29922b6c1.jpg"),
                subtitle: "Bachelor, Chemical engineering, 2018"
            ),
            .init(
                id: "member-3",
                name: "Murad Karimov",
                avatarURL: URL(string: "https://i.pinimg.com/736x/9e/52/3d/9e523d8faf76136111fa4b6f2596db1b.jpg"),
                subtitle: "Master, Data science, 2020"
            )
        ],
        roleTitles: AppUIEntities.UserActivityRole.localizedTitles()
    )
}
