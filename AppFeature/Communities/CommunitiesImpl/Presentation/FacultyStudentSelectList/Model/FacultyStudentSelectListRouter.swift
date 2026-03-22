//
//  FacultyStudentSelectListRouter.swift
//  CommunitiesImpl
//
//  Created by aplle on 3/22/26.
//

import UIKit

enum FacultyStudentSelectListRoute {
}

protocol FacultyStudentSelectListRouterProtocol {
    @MainActor
    func navigate(to route: FacultyStudentSelectListRoute)
}

final class FacultyStudentSelectListRouter: FacultyStudentSelectListRouterProtocol {
    weak var view: UIViewController?
    
    @MainActor
    func navigate(to route: FacultyStudentSelectListRoute) {
    }
}
