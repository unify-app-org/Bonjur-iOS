//
//  AuthWelcomeHostController.swift
//  AppAuthImpl
//
//  Created by Huseyn Hasanov on 26.12.25.
//

import UIKit
import AppFoundation

// MARK: - Controller

final class AuthWelcomeHostController: UIFeatureController<
    AuthWelcomeFeature,
    AuthWelcomeView
> {
    override func handleEffect(_ effect: AuthWelcomeSideEffect) {
        switch effect {
        case .loading(let isLoading):
            if isLoading {
                
            } else {
                
            }
        }
    }
}
