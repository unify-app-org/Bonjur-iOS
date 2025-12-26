//
//  AuthWelcomeRouter.swift
//  AppAuthImpl
//
//  Created by Huseyn Hasanov on 26.12.25.
//

import UIKit

enum AuthWelcomeRoute {
    case dismiss
    case optional
}

protocol AuthWelcomeRouterProtocol {
    @MainActor
    func navigate(to route: AuthWelcomeRoute)
}

final class AuthWelcomeRouter: AuthWelcomeRouterProtocol {
    weak var view: UIViewController?
    
    @MainActor
    func navigate(to route: AuthWelcomeRoute) {
        switch route {
        case .dismiss:
            view?.dismiss(animated: true)
        case .optional:
            let vc = AuthOptionalInfoBuilder(
                inputData: .init()
            ).build()
            vc.modalPresentationStyle = .fullScreen
            self.view?.present(vc, animated: true)
        }
    }
}
