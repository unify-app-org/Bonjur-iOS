//
//  StudentCardRouter.swift
//  ProfileImpl
//
//  Created by aplle on 3/4/26.
//

import UIKit
enum StudentCardRoute { case dismiss }

protocol StudentCardRouterProtocol {
    @MainActor
    func navigate(to route: StudentCardRoute)
}

final class StudentCardRouter: StudentCardRouterProtocol {
    weak var view: UIViewController?
    
    @MainActor
    func navigate(to route: StudentCardRoute) {
        switch route {
            case .dismiss:
                view?.dismiss(animated: true) 
            }
    }
}
