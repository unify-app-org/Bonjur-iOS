//
//  HangoutDetailsRouter.swift
//  HangoutsImpl
//
//  Created by Huseyn Hasanov on 02.02.26.
//

import UIKit

enum HangoutDetailsRoute {
    case back
}

protocol HangoutDetailsRouterProtocol {
    @MainActor
    func navigate(to route: HangoutDetailsRoute)
}

final class HangoutDetailsRouter: HangoutDetailsRouterProtocol {
    weak var view: UIViewController?
    
    @MainActor
    func navigate(to route: HangoutDetailsRoute) {
        switch route {
        case .back:
            view?.navigationController?.popViewController(animated: true)
        }
    }
}
