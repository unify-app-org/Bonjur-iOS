//
//  DiscoverHostController.swift
//  DiscoverImpl
//
//  Created by Huseyn Hasanov on 11.01.26.
//

import UIKit
import AppUIKit
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
                AppLoadingUI.show()
            } else {
                AppLoadingUI.dismiss()
            }
        case .error(_):
            break
        }
    }
}
