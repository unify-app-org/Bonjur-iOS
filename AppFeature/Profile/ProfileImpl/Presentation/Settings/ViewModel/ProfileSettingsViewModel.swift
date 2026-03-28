//
//  ProfileSettingsViewModel.swift
//  ProfileImpl
//
//  Created by Nahid Askerli on 26.03.26.
//

import AppFoundation
import UIKit

final class ProfileSettingsViewModel: UIFeatureViewModel<ProfileSettingsFeature> {
    
    struct Dependencies {
    }
    
    private let router: ProfileSettingsRouterProtocol
    private let inputData: ProfileSettingsInputData
    private let dependencies: ProfileSettingsViewModel.Dependencies
    
    init(
        state: ProfileSettingsFeature.State,
        router: ProfileSettingsRouterProtocol,
        inputData: ProfileSettingsInputData,
        dependencies: ProfileSettingsViewModel.Dependencies
    ) {
        self.router = router
        self.inputData = inputData
        self.dependencies = dependencies
        super.init(initialState: state)
    }
    
    override func handle(action: ProfileSettingsFeature.Action) {
        switch action {
        case .viewDidLoad:
            setupSections()
        case .didTapBack:
            Task { @MainActor in router.navigate(to: .back) }
        case .didTapLanguage:
            Task {@MainActor in router.navigate(to: .language) }
        case .didTapHelpCenter:
            Task {@MainActor in  router.navigate(to: .helpCenter)}
        case .didTapTerms:
            Task {@MainActor in  router.navigate(to: .termsAndConditions)}
        case .didTapDeleteAccount:
            Task {@MainActor in  router.navigate(to: .deleteAccount)}
        case .didTapLogOut:
            Task {@MainActor in router.navigate(to: .logout)}
        case .didToggleNotification(let isOn):
            state.notificationsEnabled = isOn
        }
    }
    
    
    private func setupSections() {
        state.sections = [
            .init(
                title: nil,
                items: [
                    .init(
                        icon: UIImage.Icons.bell,
                        title: "Notification",
                        rightIcon: UIImage.Icons.chevronright,
                        isSwitch: true
                    ),
                    .init(
                        icon: UIImage.Icons.globe01,
                        title: "Language",
                        rightIcon: UIImage.Icons.chevronright,
                        isSwitch: false,
                        action: .didTapLanguage
                    ),
                    .init(
                        icon: UIImage.Icons.chatQuestion,
                        title: "Help center",
                        rightIcon: UIImage.Icons.chevronright,
                        isSwitch: false,
                        action: .didTapHelpCenter
                    ),
                    .init(
                        icon: UIImage.Icons.clipboardList,
                        title: "Terms and conditions",
                        rightIcon: UIImage.Icons.chevronright,
                        isSwitch: false,
                        action: .didTapTerms
                    ),
                    .init(
                        icon: UIImage.Icons.mobilePhone,
                        title: "App version",
                        rightIcon: UIImage.Icons.chevronright,
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
                        rightIcon: UIImage.Icons.chevronright,
                        isSwitch: false,
                        action: .didTapDeleteAccount
                    ),
                    .init(
                        icon: UIImage.Icons.logout,
                        title: "Log out",
                        rightIcon: UIImage.Icons.chevronright,
                        isSwitch: false,
                        isDestructive: true,
                        action: .didTapLogOut
                    )
                ]
            )
        ]
    }

    
    private func fetchData() {
        
    }
}
