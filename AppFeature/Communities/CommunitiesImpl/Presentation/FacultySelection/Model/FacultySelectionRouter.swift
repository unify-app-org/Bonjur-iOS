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
    
    @MainActor
    func navigate(to route: FacultySelectionRoute) {
        switch route {
        case .facultyStudentSelection(let input):
            let vc = FacultyStudentSelectListBuilder(
                inputData: .init(title: input.title, sections: input.sections, initiallySelectedMembers: input.initiallySelectedMembers, onSelectionConfirmed: input.onSelectionConfirmed)
            ).build()
            view?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
