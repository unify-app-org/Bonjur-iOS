//
//  DiscoverHostController.swift
//  DiscoverImpl
//
//  Created by Huseyn Hasanov on 11.01.26.
//

import UIKit
import AppFoundation

// MARK: - Controller

final class DiscoverHostController: UIFeatureController<
    DiscoverFeature,
    DiscoverView
> {
    override func handleEffect(_ effect: DiscoverSideEffect) {
        switch effect {
        case .loading(let isLoading):
            if isLoading {
                
            } else {
                
            }
        case .error(_):
            break
        }
    }
}
