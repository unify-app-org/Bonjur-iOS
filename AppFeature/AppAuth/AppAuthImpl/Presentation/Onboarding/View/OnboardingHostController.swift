//
//  OnboardingHostController.swift
//  AppAuth
//
//  Created by Huseyn Hasanov on 23.12.25.
//

import UIKit
import AppFoundation

// MARK: - Controller

final class OnboardingHostController: UIFeatureController<
    OnboardingFeature,
    OnboardingView
> {
    override func handleEffect(_ effect: OnboardingSideEffect) {
        switch effect {
        case .loading(let isLoading):
            if isLoading {
                
            } else {
                
            }
        }
    }
}
