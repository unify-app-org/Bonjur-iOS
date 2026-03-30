//
//  ProfileUseCase.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 04.02.26.
//

import Foundation
import AppNetwork
import UIKit

protocol ProfileUseCase {
    func getProfileData() async throws(APIError) -> ProfileDetail.UIModel
    func fetchSections(notificationsEnabled: Bool) -> [ProfileSettingsViewState.SettingsSection]
}

class ProfileUseCaseImpl: ProfileUseCase {
    
    private let dataSource: ProfileDataSource
    
    init(dataSource: ProfileDataSource = resolve()) {
        self.dataSource = dataSource
    }
    
    func getProfileData() async throws(APIError) -> ProfileDetail.UIModel {
        .mock
    }
    
    func fetchSections(notificationsEnabled: Bool) -> [ProfileSettingsViewState.SettingsSection] {
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
