//
//  FacultySelectionRouter.swift
//  CommunitiesImpl
//
//  Created by aplle on 3/23/26.
//

import UIKit
import Communities

enum FacultySelectionRoute {
    case facultyStudentSelection(CommunitiesMemberModuleModel.FacultyStudentListSelectInput)
}

protocol FacultySelectionRouterProtocol {
    @MainActor
    func navigate(to route: FacultySelectionRoute)
}

final class FacultySelectionRouter: FacultySelectionRouterProtocol {
    weak var view: UIViewController?
    private let communitiesModule: CommunitiesModule

    init(
        view: UIViewController? = nil,
        communitiesModule: CommunitiesModule = resolve()
    ) {
        self.view = view
        self.communitiesModule = communitiesModule
    }
    
    @MainActor
    func navigate(to route: FacultySelectionRoute) {
        switch route {
        case .facultyStudentSelection(let input):
            let vc = communitiesModule.makeFacultyStudentListSelection(input: input) as! UIViewController
            view?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
