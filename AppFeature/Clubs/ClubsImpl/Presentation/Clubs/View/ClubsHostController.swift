//
//  ClubsHostController.swift
//  ClubsImpl
//
//  Created by Huseyn Hasanov on 17.01.26.
//

import UIKit
import AppFoundation

// MARK: - Controller

final class ClubsHostController: UIFeatureController<
    ClubsFeature,
    ClubsView
> {
    override func handleEffect(_ effect: ClubsSideEffect) {
        switch effect {
        case .loading(let isLoading):
            if isLoading {
                
            } else {
                
            }
        }
    }
}
