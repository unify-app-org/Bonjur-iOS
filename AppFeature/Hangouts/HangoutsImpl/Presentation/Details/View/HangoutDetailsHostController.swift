//
//  HangoutDetailsHostController.swift
//  HangoutsImpl
//
//  Created by Huseyn Hasanov on 02.02.26.
//

import UIKit
import AppFoundation

// MARK: - Controller

final class HangoutDetailsHostController: UIFeatureController<
    HangoutDetailsFeature,
    HangoutDetailsView
> {
    override func handleEffect(_ effect: HangoutDetailsSideEffect) {
        switch effect {
        case .loading(let isLoading):
            if isLoading {
                
            } else {
                
            }
        }
    }
}
