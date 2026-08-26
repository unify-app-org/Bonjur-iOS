//
//  ProfileDataSource.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 04.02.26.
//

import AppPresentationModel
import AppFoundation
import Foundation
import AppNetwork
import UIKit

protocol ProfileDataSource {
    func fetchProfile(userId: String, clubId: Int) async throws(APIError) -> AppPresentationModel.UserResponse
    func getCategories() async throws(APIError) -> [ProfileDTOModel.CategoriesResponse]
    func getLanguages() async throws(APIError) -> [ProfileDTOModel.LanguagesResponse]
    func editProfile(
        multiPart: MultipartFormData?,
        queryData: [String: String]?
    ) async throws(APIError) -> Data
    func deleteAccount() async throws(APIError) -> Data
    func fetchSections(
        notificationsEnabled: Bool
    ) -> [ProfileSettingsViewState.SettingsSection]
    func getMyClubs(userID: String) async throws(APIError) -> PageNationResponse<[ProfileDTOModel.MyClubListResponse]>
    func fetchMyHangouts(
        id: String
    ) async throws(APIError) -> PageNationResponse<[ProfileDTOModel.HangoutItem]>
    func fetchMyEvents() async throws(APIError) -> PageNationResponse<[ProfileDTOModel.MyEventResponse]>
}

final class ProfileDataSourceImpl: NetworkService<ProfileEndPoint>, ProfileDataSource {

    func fetchProfile(userId: String, clubId: Int) async throws(APIError) -> AppPresentationModel.UserResponse {
        try await fetch(endPoint: .getUserById(userId, clubId))
    }

    func getCategories() async throws(APIError) -> [ProfileDTOModel.CategoriesResponse] {
        try await fetch(endPoint: .getCategories)
    }
    
    func getLanguages() async throws(APIError) -> [ProfileDTOModel.LanguagesResponse] {
        try await fetch(endPoint: .getLanguages)
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
    
    func getMyClubs(
        userID: String
    ) async throws(APIError) -> PageNationResponse<[ProfileDTOModel.MyClubListResponse]> {
        try await fetch(endPoint: .getMyClubs(userID))
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
                        title: "settings_notification".localized,
                        rightIcon: UIImage.Icons.chevronRight,
                        isSwitch: true
                    ),
                    .init(
                        icon: UIImage.Icons.globe01,
                        title: "settings_language".localized,
                        rightIcon: UIImage.Icons.chevronRight,
                        isSwitch: false,
                        action: .didTapLanguage
                    ),
//                    .init(
//                        icon: UIImage.Icons.chatQuestion,
//                        title: "settings_help_center".localized,
//                        rightIcon: UIImage.Icons.chevronRight,
//                        isSwitch: false,
//                        action: .didTapHelpCenter
//                    ),
                    .init(
                        icon: UIImage.Icons.clipboardList,
                        title: "settings_terms".localized,
                        rightIcon: UIImage.Icons.chevronRight,
                        isSwitch: false,
                        action: .didTapTerms
                    ),
                    .init(
                        icon: UIImage.Icons.mobilePhone,
                        title: "settings_app_version".localized,
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
                        title: "settings_delete_account".localized,
                        rightIcon: UIImage.Icons.chevronRight,
                        isSwitch: false,
                        isDestructive: false,
                        action: .didTapDeleteAccount
                    ),
                    .init(
                        icon: UIImage.Icons.logout,
                        title: "settings_logout".localized,
                        rightIcon: UIImage.Icons.chevronRight,
                        isSwitch: false,
                        isDestructive: true,
                        action: .didTapLogOut
                    )
                ]
            )
        ]
    }
    
    func fetchMyHangouts(
        id: String
    ) async throws(APIError) -> PageNationResponse<[ProfileDTOModel.HangoutItem]> {
        try await fetch(endPoint: .myHangouts(id))
    }

    func fetchMyEvents() async throws(APIError) -> PageNationResponse<[ProfileDTOModel.MyEventResponse]> {
        try await fetch(endPoint: .myEvents)
    }
}
