//
//  HangoutCreateRouter.swift
//  AppFeature
//
//  Created by Codex on 30.05.26.
//

import UIKit

enum HangoutCreateRoute {
    case backTapped
}

protocol HangoutCreateRouterProtocol {
    @MainActor
    func navigate(to route: HangoutCreateRoute)
}

final class HangoutCreateRouter: HangoutCreateRouterProtocol {
    weak var view: UIViewController?
    
    @MainActor
    func navigate(to route: HangoutCreateRoute) {
        switch route {
        case .backTapped:
            view?.navigationController?.popViewController(animated: true)
        }
    }
}
