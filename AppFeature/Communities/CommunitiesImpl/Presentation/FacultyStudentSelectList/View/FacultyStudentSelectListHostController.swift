//
//  FacultyStudentSelectListHostController.swift
//  CommunitiesImpl
//
//  Created by aplle on 3/22/26.
//

import UIKit
import AppFoundation

// MARK: - Controller

final class FacultyStudentSelectListHostController: UIFeatureController<
    FacultyStudentSelectListFeature,
    FacultyStudentSelectListView
> {
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if isMovingFromParent {
            store.send(.didPop)
        }
    }

    override func handleEffect(_ effect: FacultyStudentSelectListSideEffect) {
        switch effect {
        case .loading:
            break
        }
    }
}
