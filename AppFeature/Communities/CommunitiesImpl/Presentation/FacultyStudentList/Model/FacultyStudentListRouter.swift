//
//  FacultyStudentListRouter.swift
//  CommunitiesImpl
//
//  Created by aplle on 3/22/26.
//

import UIKit

enum FacultyStudentListRoute {
}

protocol FacultyStudentListRouterProtocol {
    @MainActor
    func navigate(to route: FacultyStudentListRoute)
}

final class FacultyStudentListRouter: FacultyStudentListRouterProtocol {
    weak var view: UIViewController?
    
    @MainActor
    func navigate(to route: FacultyStudentListRoute) {
    }
}
