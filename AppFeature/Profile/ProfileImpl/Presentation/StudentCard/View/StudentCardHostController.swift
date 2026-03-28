//
//  StudentCardHostController.swift
//  ProfileImpl
//
//  Created by aplle on 3/4/26.
//

import UIKit
import AppFoundation

// MARK: - Controller

final class StudentCardHostController: UIFeatureController<
    StudentCardFeature,
    StudentCardView
> {
    override func handleEffect(_ effect: StudentCardSideEffect) {
        switch effect {
        case .loading(let isLoading):
            if isLoading {
                
            } else {
                
            }
        }
    }
}
