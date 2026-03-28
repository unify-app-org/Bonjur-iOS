//
//  FacultyBrowseRouter.swift
//  CommunitiesImpl
//
//  Created by aplle on 3/21/26.
//

import UIKit

enum FacultyBrowseRoute {
}

protocol FacultyBrowseRouterProtocol {
    @MainActor
    func navigate(to route: FacultyBrowseRoute)
}

final class FacultyBrowseRouter: FacultyBrowseRouterProtocol {
    weak var view: UIViewController?
    
    @MainActor
    func navigate(to route: FacultyBrowseRoute) {
    }
}
