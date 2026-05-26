//
//  GroupsUseCase.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 23.01.26.
//

import AppUIKit
import AppNetwork
import Events
import Clubs
import Hangouts

protocol GroupsUseCase {
    func fetchEvents() async throws(APIError) -> [EventsModuleModel.CardInputData]
    func fetchClubs(
        query: GroupsDTOModel.PaginationQuery
    ) async throws(APIError) -> [ClubsModuleModel.CardInputData]
    func fetchHangouts(
        query: GroupsDTOModel.PaginationQuery
    ) async throws(APIError) -> [HangoutsModuleModel.CardInputData]
}

class GroupsUseCaseImpl: GroupsUseCase {
    
    private let repo: GroupsRepo
    
    init(repo: GroupsRepo = resolve()) {
        self.repo = repo
    }

    func fetchEvents() async throws(APIError) -> [EventsModuleModel.CardInputData] {
        EventsModuleModel.CardInputData.previewMock
    }
    
    func fetchClubs(
        query: GroupsDTOModel.PaginationQuery
    ) async throws(APIError) -> [ClubsModuleModel.CardInputData] {
        try await repo.fetchJoinedClubs(query: query)
    }
    
    func fetchHangouts(
        query: GroupsDTOModel.PaginationQuery
    ) async throws(APIError) -> [HangoutsModuleModel.CardInputData] {
        try await repo.fetchJoinedHangouts(query: query)
    }
}

