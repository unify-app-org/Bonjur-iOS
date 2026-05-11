//
//  EditProfileRouter.swift
//  ProfileImpl
//
//  Created by Huseyn Hasanov on 11.05.26.
//

import UIKit

enum EditProfileRoute {
    case popBack
}

protocol EditProfileRouterProtocol {
    @MainActor
    func navigate(to route: EditProfileRoute)
}

final class EditProfileRouter: EditProfileRouterProtocol {
    weak var view: UIViewController?
    
    @MainActor
    func navigate(to route: EditProfileRoute) {
        switch route {
        case .popBack:
            view?.navigationController?.popViewController(animated: true)
        }
    }
}
