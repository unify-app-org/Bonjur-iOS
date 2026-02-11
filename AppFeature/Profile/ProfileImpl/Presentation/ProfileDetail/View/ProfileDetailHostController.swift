//
//  ProfileDetailHostController.swift
//  ProfileImpl
//
//  Created by Huseyn Hasanov on 04.02.26.
//

import UIKit
import AppFoundation

// MARK: - Controller

final class ProfileDetailHostController: UIFeatureController<
    ProfileDetailFeature,
    ProfileDetailView
> {
    override func handleEffect(_ effect: ProfileDetailSideEffect) {
        switch effect {
        case .loading(let isLoading):
            if isLoading {
                
            } else {
                
            }
        }
    }
}
