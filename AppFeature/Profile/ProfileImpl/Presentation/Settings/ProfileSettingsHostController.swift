//
//  ProfileSettingsHostController.swift
//  AppFeature
//
//  Created by Nahid Askerli on 26.02.26.
//

import UIKit
import AppFoundation

// MARK: - Controller

final class ProfileSettingsHostController: UIFeatureController<
    ProfileSettingsFeature,
    ProfileSettingsView
> {
    override func handleEffect(_ effect: ProfileSettingsSideEffect) {
        switch effect {
        case .loading(let isLoading):
            if isLoading {
                
            } else {
                
            }
        }
    }
}
