//
//  ClubsUseCase.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 20.01.26.
//

import AppUIKit
import AppNetwork

protocol ClubsUseCase {
    func fetchClubsData() async throws(APIError) -> [ClubCardView.Model]
    func fetchClubDetails(clubId: Int) async throws(APIError) -> ClubsDetailsModel.UIModel
    func fetchCreateFields() async throws(APIError) -> [ClubsCreate.FieldSchema]
    func getCategories() async throws(APIError) -> [SelectCategoryView.Section]
    func createClub(request: MultipartFormData) async throws(APIError) -> Void
}

class ClubsUseCaseImpl: ClubsUseCase {
    
    private let repo: ClubRepo
    
    init(repo: ClubRepo = resolve()) {
        self.repo = repo
    }

    func fetchClubsData() async throws(APIError) -> [ClubCardView.Model] {
        ClubCardView.Model.previewData
    }
    
    func fetchClubDetails(
        clubId: Int
    ) async throws(APIError) -> ClubsDetailsModel.UIModel {
        .mockData
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
}
