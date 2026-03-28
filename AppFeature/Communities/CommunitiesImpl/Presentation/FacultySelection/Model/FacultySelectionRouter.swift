//
//  FacultySelectionRouter.swift
//  CommunitiesImpl
//
//  Created by aplle on 3/23/26.
//

import UIKit

enum FacultySelectionRoute {
}

protocol FacultySelectionRouterProtocol {
    @MainActor
    func navigate(to route: FacultySelectionRoute)
}

final class FacultySelectionRouter: FacultySelectionRouterProtocol {
    weak var view: UIViewController?
    
    @MainActor
    func navigate(to route: FacultySelectionRoute) {
    }
}
