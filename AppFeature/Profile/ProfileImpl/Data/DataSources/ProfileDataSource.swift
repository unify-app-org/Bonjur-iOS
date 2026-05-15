//
//  ProfileDataSource.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 04.02.26.
//

import AppPresentationModel
import Foundation
import AppNetwork
import UIKit

protocol ProfileDataSource {
    func fetchProfile(userId: String) async throws(APIError) -> AppPresentationModel.UserResponse
    func getCategories() async throws(APIError) -> [ProfileDTOModel.CategoriesResponse]
    func editProfile(
        multiPart: MultipartFormData?,
        queryData: [String: String]?
    ) async throws(APIError) -> Data
    func deleteAccount() async throws(APIError) -> Data
    func fetchSections(
        notificationsEnabled: Bool
    ) -> [ProfileSettingsViewState.SettingsSection]
}

final class ProfileDataSourceImpl: NetworkService<ProfileEndPoint>, ProfileDataSource {

    func fetchProfile(userId: String) async throws(APIError) -> AppPresentationModel.UserResponse {
        try await fetch(endPoint: .getUserById(userId))
    }

    func getCategories() async throws(APIError) -> [ProfileDTOModel.CategoriesResponse] {
        try await fetch(endPoint: .getCategories)
    }
    
    func editProfile(
        multiPart: MultipartFormData?,
        queryData: [String: String]?
    ) async throws(APIError) -> Data {
        try await fetchRawData(endPoint: .updateUserData(queryData, multiPart))
    }
    
    func deleteAccount() async throws(APIError) -> Data {
        try await fetchRawData(endPoint: .deleteAccount)
    }
    
    func fetchSections(
        notificationsEnabled: Bool
    ) -> [ProfileSettingsViewState.SettingsSection] {
        return [
            .init(
                title: nil,
                items: [
                    .init(
                        icon: UIImage.Icons.bell,
                        title: "Notification",
                        rightIcon: UIImage.Icons.chevronRight,
                        isSwitch: true
                    ),
                    .init(
                        icon: UIImage.Icons.globe01,
                        title: "Language",
                        rightIcon: UIImage.Icons.chevronRight,
                        isSwitch: false,
                        action: .didTapLanguage
                    ),
                    .init(
                        icon: UIImage.Icons.chatQuestion,
                        title: "Help center",
                        rightIcon: UIImage.Icons.chevronRight,
                        isSwitch: false,
                        action: .didTapHelpCenter
                    ),
                    .init(
                        icon: UIImage.Icons.clipboardList,
                        title: "Terms and conditions",
                        rightIcon: UIImage.Icons.chevronRight,
                        isSwitch: false,
                        action: .didTapTerms
                    ),
                    .init(
                        icon: UIImage.Icons.mobilePhone,
                        title: "App version",
                        rightIcon: UIImage.Icons.chevronRight,
                        isSwitch: false,
                        versionText: "1.24.0"
                    )
                ]
            ),
            .init(
                title: nil,
                items: [
                    .init(
                        icon: UIImage.Icons.trash,
                        title: "Delete account",
                        rightIcon: UIImage.Icons.chevronRight,
                        isSwitch: false,
                        isDestructive: false,
                        action: .didTapDeleteAccount
                    ),
                    .init(
                        icon: UIImage.Icons.logout,
                        title: "Log out",
                        rightIcon: UIImage.Icons.chevronRight,
                        isSwitch: false,
                        isDestructive: true,
                        action: .didTapLogOut
                    )
                ]
            )
        ]
    }
}
