//
//  ClubsUseCase.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 20.01.26.
//

import AppUIKit
import AppNetwork
import Communities
import AppPresentationModel

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
    func fetchClubMembersPage(
        id: Int,
        page: Int,
        size: Int
    ) async throws(APIError) -> CommunitiesMemberModuleModel.MembersPage
    func editClub(
        id: Int,
        request: MultipartFormData
    ) async throws(APIError)
    func joinClub(
        id: Int
    ) async throws(APIError)
    func assignRole(
        clubId: Int,
        userId: String,
        role: AppPresentationModel.UserActivityRole
    ) async throws(APIError)
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
    
    func editClub(
        id: Int,
        request: MultipartFormData
    ) async throws(APIError) {
        try await repo.editClub(id: id, request: request)
    }
    
    func fetchClubMembersPage(
        id: Int,
        page: Int,
        size: Int
    ) async throws(APIError) -> CommunitiesMemberModuleModel.MembersPage {
        try await repo.fetchClubMembersPage(id: id, page: page, size: size)
    }

    func fetchClubMemberById(
        id: Int
    ) async throws(APIError) -> CommunitiesMemberModuleModel.GroupedMembersData {
        try await repo.fetchClubMemberById(id: id)
    }
    
    func joinClub(id: Int) async throws(APIError) {
        try await repo.joinClub(id: id)
    }

    func assignRole(
        clubId: Int,
        userId: String,
        role: AppPresentationModel.UserActivityRole
    ) async throws(APIError) {
        try await repo.assignRole(clubId: clubId, userId: userId, role: role)
    }
}
