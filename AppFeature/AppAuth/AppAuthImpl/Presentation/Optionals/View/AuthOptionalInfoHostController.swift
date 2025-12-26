//
//  AuthOptionalInfoHostController.swift
//  AppAuthImpl
//
//  Created by Huseyn Hasanov on 26.12.25.
//

import UIKit
import AppFoundation

// MARK: - Controller

final class AuthOptionalInfoHostController: UIFeatureController<
    AuthOptionalInfoFeature,
    AuthOptionalInfoView
> {
    override func handleEffect(_ effect: AuthOptionalInfoSideEffect) {
        switch effect {
        case .loading(let isLoading):
            if isLoading {
                
            } else {
                
            }
        }
    }
}
