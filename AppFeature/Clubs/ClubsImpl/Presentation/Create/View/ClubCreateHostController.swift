//
//  ClubCreateHostController.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 21.02.26.
//

import UIKit
import AppFoundation

// MARK: - Controller

final class ClubCreateHostController: UIFeatureController<
    ClubCreateFeature,
    ClubCreateView
> {
    override func handleEffect(_ effect: ClubCreateSideEffect) {
        switch effect {
        case .loading(let isLoading):
            if isLoading {
                
            } else {
                
            }
        }
    }
}
