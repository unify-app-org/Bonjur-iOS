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

protocol ProfileUseCase {
    func getProfileData() async throws(APIError) -> ProfileDetail.UIModel
    func getCategories() async throws(APIError) -> [SelectCategoryView.Section]
    func fetchSections(notificationsEnabled: Bool) -> [ProfileSettingsViewState.SettingsSection]
    func editProfile(
        multiPart: MultipartFormData?,
        queryData: ProfileDTOModel.UpdateRequest?
    ) async throws(APIError) -> Data
    func deleteAccount() async throws(APIError) -> Data
}

class ProfileUseCaseImpl: ProfileUseCase {
    
    private let repo: ProfileRepo
    
    init(repo: ProfileRepo = resolve()) {
        self.repo = repo
    }
    
    func getProfileData() async throws(APIError) -> ProfileDetail.UIModel {
        try await repo.getUsers()
    }

    func getCategories() async throws(APIError) -> [SelectCategoryView.Section] {
        try await repo.getCategories()
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
}
