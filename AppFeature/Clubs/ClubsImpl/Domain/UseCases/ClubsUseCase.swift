//
//  ClubsUseCase.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 20.01.26.
//

import AppUIKit
import AppNetwork
import Communities

protocol ClubsUseCase {
    func fetchClubsData(
        query: ClubDTOModel.PaginationQuery
    ) async throws(APIError) -> [ClubCardView.Model]
    func fetchClubDetails(clubId: Int) async throws(APIError) -> ClubsDetailsModel.UIModel
    func fetchCreateFields() async throws(APIError) -> [ClubsCreate.FieldSchema]
    func getCategories() async throws(APIError) -> [SelectCategoryView.Section]
    func createClub(request: MultipartFormData) async throws(APIError) -> Void
    func fetchClubMemberById(
        id: Int
    ) async throws(APIError) -> CommunitiesMemberModuleModel.GroupedMembersData
}

class ClubsUseCaseImpl: ClubsUseCase {
    
    private let repo: ClubRepo
    
    init(repo: ClubRepo = resolve()) {
        self.repo = repo
    }

    func fetchClubsData(
        query: ClubDTOModel.PaginationQuery
    ) async throws(APIError) -> [ClubCardView.Model] {
        try await repo.fetchClubs(query: query)
    }
    
    func fetchClubDetails(
        clubId: Int
    ) async throws(APIError) -> ClubsDetailsModel.UIModel {
        try await repo.fetchClubDetails(clubId: clubId)
    }
    
    func fetchCreateFields() async throws(APIError) -> [ClubsCreate.FieldSchema] {
        try await repo.fetchCreate()
    }
    
    func getCategories() async throws(APIError) -> [SelectCategoryView.Section] {
        try await repo.getCategories()
    }
    
    func createClub(request: MultipartFormData) async throws(APIError) {
        try await repo.createClub(request: request)
    }
    
    func fetchClubMemberById(
        id: Int
    ) async throws(APIError) -> CommunitiesMemberModuleModel.GroupedMembersData {
        try await repo.fetchClubMemberById(id: id)
    }
}
