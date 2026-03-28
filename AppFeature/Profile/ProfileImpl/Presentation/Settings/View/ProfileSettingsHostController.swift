//
//  ProfileSettingsHostController.swift
//  ProfileImpl
//
//  Created by Nahid Askerli on 26.03.26.
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
