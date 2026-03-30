//
//  ProfileSettingsModel.swift
//  ProfileImpl
//
//  Created by Nahid Askerli on 26.03.26.
//

import AppFoundation
import Combine
import SwiftUI

// MARK: - ProfileSettings input

struct ProfileSettingsInputData {
}

// MARK: - Side effects

enum ProfileSettingsSideEffect: UISideEffect {
    case loading(Bool)
}

// MARK: - Feature Definition

typealias ProfileSettingsFeature = UIFeatureDefinition<
    ProfileSettingsViewState,
    ProfileSettingsAction,
    ProfileSettingsSideEffect
>

// MARK: - View State

final class ProfileSettingsViewState: UIFeatureState {
    
    struct SettingsModel: Identifiable {
        let id = UUID()
        let icon: UIImage
        let title: String
        let rightIcon: UIImage
        let isSwitch: Bool
        var isDestructive: Bool = false
        var versionText: String? = nil
        var action: ProfileSettingsAction? = nil
    }

    struct SettingsSection: Identifiable {
        let id = UUID()
        let title: String?
        let items: [SettingsModel]
    }
    
    @Published var notificationsEnabled: Bool = true
    @Published var sections: [SettingsSection] = []
}

// MARK: - Feature Action

enum ProfileSettingsAction: UIFeatureAction {
    case fetchData
    case didTapBack
    case didTapLanguage
    case didTapHelpCenter
    case didTapTerms
    case didTapDeleteAccount
    case didTapLogOut
    case didToggleNotification(Bool)
}
