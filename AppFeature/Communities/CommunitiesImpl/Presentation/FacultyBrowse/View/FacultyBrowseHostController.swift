//
//  FacultyBrowseHostController.swift
//  CommunitiesImpl
//
//  Created by aplle on 3/21/26.
//

import UIKit
import AppFoundation

// MARK: - Controller

final class FacultyBrowseHostController: UIFeatureController<
    FacultyBrowseFeature,
    FacultyBrowseView
> {
    override func handleEffect(_ effect: FacultyBrowseSideEffect) {
        switch effect {
        case .loading(let isLoading):
            if isLoading {
                
            } else {
                
            }
        }
    }
}
