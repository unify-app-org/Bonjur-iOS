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

    func getCategories() async throws(APIError) -> [SelectCategoryView.Section]

    func fetchCreateFields() async throws(APIError) -> [HangoutsCreate.FieldSchema]

    func createHangout(
        request: HangoutsDTOModel.Request
    ) async throws(APIError) -> Void

    func editHangout(
        id: String,
        request: HangoutsDTOModel.Request
    ) async throws(APIError) -> Void

    func fetchDetailHangoutMembers(
        id: String
    ) async throws(APIError) -> CommunitiesMemberModuleModel.GroupedMembersData

    func fetchHangoutMembersPage(
        id: String,
        page: Int,
        size: Int
    ) async throws(APIError) -> CommunitiesMemberModuleModel.MembersPage

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

    func getCategories() async throws(APIError) -> [SelectCategoryView.Section] {
        try await repo.getCategories()
    }

    func fetchCreateFields() async throws(APIError) -> [HangoutsCreate.FieldSchema] {
        try await repo.fetchCreate()
    }

    func createHangout(
        request: HangoutsDTOModel.Request
    ) async throws(APIError) {
        try await repo.createHangout(request: request)
    }

    func editHangout(
        id: String,
        request: HangoutsDTOModel.Request
    ) async throws(APIError) {
        try await repo.editHangout(id: id, request: request)
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

    func fetchHangoutMembersPage(
        id: String,
        page: Int,
        size: Int
    ) async throws(APIError) -> CommunitiesMemberModuleModel.MembersPage {
        try await repo.fetchHangoutMembersPage(id: id, page: page, size: size)
    }
}
