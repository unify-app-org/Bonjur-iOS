//
//  ProfileUseCase.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 04.02.26.
//

import Foundation
import AppNetwork
import UIKit
import AppUIKit
import Clubs

protocol ProfileUseCase {
    func getProfileData(userId: String?) async throws(APIError) -> ProfileDetail.UIModel
    func getCategories() async throws(APIError) -> [SelectCategoryView.Section]
    func getLanguages() async throws(APIError) -> [SelectableListItemView.Model]
    func fetchSections(notificationsEnabled: Bool) -> [ProfileSettingsViewState.SettingsSection]
    func editProfile(
        multiPart: MultipartFormData?,
        queryData: ProfileDTOModel.UpdateRequest?
    ) async throws(APIError) -> Data
    func deleteAccount() async throws(APIError) -> Data
    func getMyClubs(userId: String?) async throws(APIError) -> [ClubsModuleModel.CardInputData]
}

class ProfileUseCaseImpl: ProfileUseCase {
    
    private let repo: ProfileRepo
    
    init(repo: ProfileRepo = resolve()) {
        self.repo = repo
    }
    
    func getProfileData(userId: String?) async throws(APIError) -> ProfileDetail.UIModel {
        try await repo.getUsers(userId: userId)
    }

    func getCategories() async throws(APIError) -> [SelectCategoryView.Section] {
        try await repo.getCategories()
    }
    
    func getLanguages() async throws(APIError) -> [SelectableListItemView.Model] {
        try await repo.getLanguages()
    }
    
    func editProfile(
        multiPart: MultipartFormData?,
        queryData: ProfileDTOModel.UpdateRequest?
    ) async throws(APIError) -> Data {
        try await repo.editProfile(
            multiPart: multiPart,
            queryData: queryData
        )
    }

    func fetchSections(
        notificationsEnabled: Bool
    ) -> [ProfileSettingsViewState.SettingsSection] {
        repo.fetchSections(
            notificationsEnabled: notificationsEnabled
        )
    }
    
    func deleteAccount() async throws(APIError) -> Data {
        try await repo.deleteAccount()
    }
    
    func getMyClubs(
        userId: String?
    ) async throws(APIError) -> [ClubsModuleModel.CardInputData] {
        try await repo.getMyClubs(userId: userId)
    }
}
