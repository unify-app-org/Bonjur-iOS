//
//  ClubDetailsRouter.swift
//  AppAuth
//
//  Created by Huseyn Hasanov on 29.01.26.
//

import UIKit

enum ClubDetailsRoute {
    case backTapped
}

protocol ClubDetailsRouterProtocol {
    @MainActor
    func navigate(to route: ClubDetailsRoute)
}

final class ClubDetailsRouter: ClubDetailsRouterProtocol {
    weak var view: UIViewController?
    
    @MainActor
    func navigate(to route: ClubDetailsRoute) {
        switch route {
        case .backTapped:
            self.view?.navigationController?.popViewController(animated: true)
        }
    }
}
