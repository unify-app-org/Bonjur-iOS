//
//  AppTabBarHostController.swift
//  App
//
//  Created by Huseyn Hasanov on 01.01.26.
//  Copyright © 2026 Bonjur. All rights reserved.
//

import UIKit
import AppFoundation

// MARK: - Controller

final class AppTabBarHostController: UIFeatureController<
    AppTabBarFeature,
    AppTabBarView
> {
    override func handleEffect(_ effect: AppTabBarSideEffect) {
        switch effect {
        case .loading(let isLoading):
            if isLoading {
                
            } else {
                
            }
        }
    }
}
