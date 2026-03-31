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
    
    @MainActor
    func navigate(to route: FacultyBrowseRoute) {
        switch route {
        case .facultyStudentList(let input):
            let vc = FacultyStudentListBuilder(
                inputData: .init(title: input.title, sections: input.sections, onMemberTapped: input.onMemberTapped)
            ).build()
            view?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
