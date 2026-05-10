//
//  ProfileRepo.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 11.05.26.
//

import AppUIKit
import AppNetwork
import Foundation
import Clubs
import Events
import Hangouts

protocol ProfileRepo {
    func getUsers() async throws(APIError) -> ProfileDetail.UIModel
}

class ProfileRepoImpl: ProfileRepo {
    
    private let dataSource: ProfileDataSource
    
    init(
        dataSource: ProfileDataSource = resolve()
    ) {
        self.dataSource = dataSource
    }
    
    func getUsers() async throws(APIError) -> ProfileDetail.UIModel {
        let data = try await dataSource.fetchProfile()
        let userCardModel: UserCardModel = .init(
            backgroundCover: .primary,
            nameSurname: data.username ?? "-",
            speciality: data.specialization ?? "-",
            course: data.faculty ?? "",
            community: "-",
            degree: data.degree ?? "-",
            entryYear: String(data.entryYear ?? 2000),
            email: data.mail ?? "",
            imageUrl: URL(string: "")
        )
        let languages = data.languages?.map({ $0.name ?? "" })
        let tags: [AppUIEntities.Tags] = data.categories?.map { item in
                .init(
                    id: item.id ?? 0,
                    type: "",
                    title: item.title ?? "-"
                )
        } ?? []
        let uiModel: ProfileDetail.UIModel = .init(
            userCardModel: userCardModel,
            about: data.about,
            gender: data.gender,
            birthday: data.birthDate,
            languages: languages,
            tags: tags,
            clubs: ClubsModuleModel.CardInputData.previewMock,
            events: EventsModuleModel.CardInputData.previewMock,
            hangouts: HangoutsModuleModel.CardInputData.previewMock
        )
        return uiModel
    }
}
