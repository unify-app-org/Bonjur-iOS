//
//  HangoutListHostController.swift
//  HangoutsImpl
//
//  Created by Huseyn Hasanov on 22.01.26.
//

import UIKit
import AppFoundation

// MARK: - Controller

final class HangoutListHostController: UIFeatureController<
    HangoutListFeature,
    HangoutListView
> {
    override func handleEffect(_ effect: HangoutListSideEffect) {
        switch effect {
        case .error(_):
            break
        case .loading(let isLoading):
            if isLoading {
                
            } else {
                
            }
        }
    }
}
