//
//  FacultyBrowseRouter.swift
//  CommunitiesImpl
//
//  Created by aplle on 3/21/26.
//

import UIKit
import Communities

enum FacultyBrowseRoute {
    case facultyStudentList(CommunitiesMemberModuleModel.FacultyStudentListViewInput)
}

protocol FacultyBrowseRouterProtocol {
    @MainActor
    func navigate(to route: FacultyBrowseRoute)
}

final class FacultyBrowseRouter: FacultyBrowseRouterProtocol {
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
    func navigate(to route: FacultyBrowseRoute) {
        switch route {
        case .facultyStudentList(let input):
            let vc = communitiesModule.makeFacultyStudentListView(input: input) as! UIViewController
            view?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
