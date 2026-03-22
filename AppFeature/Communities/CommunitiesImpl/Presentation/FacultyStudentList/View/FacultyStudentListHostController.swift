//
//  FacultyStudentListHostController.swift
//  CommunitiesImpl
//
//  Created by aplle on 3/22/26.
//

import UIKit
import AppFoundation

// MARK: - Controller

final class FacultyStudentListHostController: UIFeatureController<
    FacultyStudentListFeature,
    FacultyStudentListView
> {
    override func handleEffect(_ effect: FacultyStudentListSideEffect) {
        switch effect {
        case .loading(let isLoading):
            if isLoading {
                
            } else {
                
            }
        }
    }
}
