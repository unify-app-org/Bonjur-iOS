//
//  ClubDetailsHostController.swift
//  AppAuth
//
//  Created by Huseyn Hasanov on 29.01.26.
//

import UIKit
import AppFoundation

// MARK: - Controller

final class ClubDetailsHostController: UIFeatureController<
    ClubDetailsFeature,
    ClubDetailsView
> {

    override func handleEffect(_ effect: ClubDetailsSideEffect) {
        switch effect {
        case .loading(let isLoading):
            if isLoading {
                
            } else {
                
            }
        }
    }
}
