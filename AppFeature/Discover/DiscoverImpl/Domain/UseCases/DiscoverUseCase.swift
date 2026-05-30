//
//  DiscoverUseCases.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 17.01.26.
//

import AppUIKit
import AppNetwork
import Clubs
import Events
import Hangouts
import Communities

protocol DiscoverUseCase {
    func fetchUserData() async throws(APIError) -> UserModel
    
    func fetchCategories() async throws(APIError) -> [FilterView.Model]
    
    func fetchCommunitiesData(
        query: DiscoverDTOModel.PaginationQuery
    ) async throws(APIError) -> [CommunitiesModuleModel.CardInputData]
    
    func fetchClubsData(
        query: DiscoverDTOModel.PaginationQuery
    ) async throws(APIError) -> [ClubsModuleModel.CardInputData]
    
    func fetchEventsData() async throws(APIError) -> [EventsModuleModel.CardInputData]
    
    func fetchHangoutsData(
        query: DiscoverDTOModel.PaginationQuery
    ) async throws(APIError) -> [HangoutsModuleModel.CardInputData]
}

class DiscoverUseCaseImpl: DiscoverUseCase {
    
    private let repo: DiscoverRepo
    
    init(repo: DiscoverRepo = resolve()) {
        self.repo = repo
    }
    
    func fetchUserData() async throws(APIError) -> UserModel {
        try await repo.getUser()
    }
    
    func fetchCategories() async throws(APIError) -> [FilterView.Model] {
        try await repo.getCategories()
    }
    
    func fetchCommunitiesData(
        query: DiscoverDTOModel.PaginationQuery
    ) async throws(APIError) -> [CommunitiesModuleModel.CardInputData] {
        try await repo.getCommunities(query: query)
    }
    
    func fetchClubsData(
        query: DiscoverDTOModel.PaginationQuery
    ) async throws(APIError) -> [ClubsModuleModel.CardInputData] {
        try await repo.getClubs(query: query)
    }
    
    func fetchEventsData() async throws(APIError) -> [EventsModuleModel.CardInputData] {
        EventsModuleModel.CardInputData.previewMock
    }
    
    func fetchHangoutsData(
        query: DiscoverDTOModel.PaginationQuery
    ) async throws(APIError) -> [HangoutsModuleModel.CardInputData] {
        try await repo.getHangout(query: query)
    }
}
