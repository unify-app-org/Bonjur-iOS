//
//  HangoutsUseCase.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 22.01.26.
//

import AppUIKit
import AppNetwork
import Communities

protocol HangoutsUseCase {
    func fetchHangouts(
        query: HangoutsDTOModel.PaginationQuery
    ) async throws(APIError) -> [HangoutsCardView.Model]
    
    func fetchDetailHangoutMembers(
        id: String
    ) async throws(APIError) -> CommunitiesMemberModuleModel.GroupedMembersData

    func fetchDetailHangout(id: String) async throws(APIError) -> HangoutDetails.UIModel
}

class HangoutsUseCaseImpl: HangoutsUseCase {
    
    private let repo: HangoutRepo
    
    init(repo: HangoutRepo = resolve()) {
        self.repo = repo
    }
    
    func fetchHangouts(
        query: HangoutsDTOModel.PaginationQuery
    ) async throws(APIError) -> [HangoutsCardView.Model] {
        try await repo.fetchHangouts(query: query)
    }
    
    func fetchDetailHangout(
        id: String
    ) async throws(APIError) -> HangoutDetails.UIModel {
        try await repo.fetchDetailHangout(id: id)
    }
    
    func fetchDetailHangoutMembers(
        id: String
    ) async throws(APIError) -> CommunitiesMemberModuleModel.GroupedMembersData {
        try await repo.fetchDetailHangoutMembers(id: id)
    }
}
