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
    func fetchEvents(
        query: GroupsDTOModel.PaginationQuery
    ) async throws(APIError) -> Page<EventsModuleModel.CardInputData>
    func fetchClubs(
        query: GroupsDTOModel.PaginationQuery
    ) async throws(APIError) -> Page<ClubsModuleModel.CardInputData>
    func fetchHangouts(
        query: GroupsDTOModel.PaginationQuery
    ) async throws(APIError) -> Page<HangoutsModuleModel.CardInputData>
}

class GroupsUseCaseImpl: GroupsUseCase {
    
    private let repo: GroupsRepo
    
    init(repo: GroupsRepo = resolve()) {
        self.repo = repo
    }

    func fetchEvents(
        query: GroupsDTOModel.PaginationQuery
    ) async throws(APIError) -> Page<EventsModuleModel.CardInputData> {
        try await repo.fetchJoinedEvents(query: query)
    }
    
    func fetchClubs(
        query: GroupsDTOModel.PaginationQuery
    ) async throws(APIError) -> Page<ClubsModuleModel.CardInputData> {
        try await repo.fetchJoinedClubs(query: query)
    }
    
    func fetchHangouts(
        query: GroupsDTOModel.PaginationQuery
    ) async throws(APIError) -> Page<HangoutsModuleModel.CardInputData> {
        try await repo.fetchJoinedHangouts(query: query)
    }
}

