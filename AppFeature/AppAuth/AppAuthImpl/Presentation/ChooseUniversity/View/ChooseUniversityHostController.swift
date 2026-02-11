//
//  ChooseUniversityHostController.swift
//  AppAuthImpl
//
//  Created by Huseyn Hasanov on 26.12.25.
//

import UIKit
import AppFoundation

// MARK: - Controller

final class ChooseUniversityHostController: UIFeatureController<
    ChooseUniversityFeature,
    ChooseUniversityView
> {
    override func handleEffect(_ effect: ChooseUniversitySideEffect) {
        switch effect {
        case .loading(let isLoading):
            if isLoading {
                
            } else {
                
            }
        }
    }
}
