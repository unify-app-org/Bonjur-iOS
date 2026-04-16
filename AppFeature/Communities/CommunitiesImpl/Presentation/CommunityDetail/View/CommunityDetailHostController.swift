//
//  CommunityDetailHostController.swift
//  CommunitiesImpl
//
//  Created by Huseyn Hasanov on 03.02.26.
//

import UIKit
import AppFoundation

// MARK: - Controller

final class CommunityDetailHostController: UIFeatureController<
    CommunityDetailFeature,
    CommunityDetailView
> {

    override func handleEffect(_ effect: CommunityDetailSideEffect) {
        switch effect {
        case .loading(let isLoading):
            if isLoading {
                
            } else {
                
            }
        }
    }
}
