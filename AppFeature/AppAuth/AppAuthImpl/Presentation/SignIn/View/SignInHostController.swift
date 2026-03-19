//
//  SignInHostController.swift
//  AppAuthImpl
//
//  Created by Huseyn Hasanov on 06.01.26.
//

import UIKit
import AppFoundation
import AppUIKit

// MARK: - Controller

final class SignInHostController: UIFeatureController<
    SignInFeature,
    SignInView
> {
    override func handleEffect(_ effect: SignInSideEffect) {
        switch effect {
        case .loading(let isLoading):
            if isLoading {
                AppLoadingUI.show()
            } else {
                AppLoadingUI.dismiss()
            }
        }
    }
}
