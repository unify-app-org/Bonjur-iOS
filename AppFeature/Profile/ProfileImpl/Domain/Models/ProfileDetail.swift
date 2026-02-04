//
//  ProfileDetail.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 04.02.26.
//

import Foundation
import AppUIKit
import Clubs
import Events
import Hangouts

enum ProfileDetail {
    
    struct UIModel {
        let userCardModel: UserCardModel
        let about: String?
        let gender: String?
        let birthday: String?
        let languages: [String]?
        let tags: [AppUIEntities.Tags]
        let cardCover: AppUIEntities.BackgroundType?
        let clubs: [ClubsModuleModel.CardInputData]
        let events: [EventsModuleModel.CardInputData]
        let hangouts: [HangoutsModuleModel.CardInputData]
    }
}


extension ProfileDetail.UIModel {
    static let mock: Self = .init(
        userCardModel: .mock.last!,
        about: "I want to have a coffee and then go to the film I have one free ticket to the concert for the Sunday evening if someone want just contact.",
        gender: "Male",
        birthday: nil,
        languages: nil,
        tags: [
            .init(id: 1, type: "SPORT", title: "Messi"),
            .init(id: 1, type: "SPORT", title: "Ronaldo"),
            .init(id: 1, type: "SPORT", title: "Ronaldinho"),
            .init(id: 1, type: "SPORT", title: "Basketball")
        ],
        cardCover: .teritary,
        clubs: ClubsModuleModel.CardInputData.previewMock,
        events: EventsModuleModel.CardInputData.previewMock,
        hangouts: HangoutsModuleModel.CardInputData.previewMock
    )
}
