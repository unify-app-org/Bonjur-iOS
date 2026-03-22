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
    override func handleEffect(_ effect: FacultyStudentSelectListSideEffect) {
        switch effect {
        case .loading(let isLoading):
            if isLoading {
                
            } else {
                
            }
        case .capacityLimitReached(overflowCount: let overflowCount):
            break
        }
    }
}
