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
    case dashboard
}

protocol AuthWelcomeRouterProtocol {
    @MainActor
    func navigate(to route: AuthWelcomeRoute)
}

final class AuthWelcomeRouter: AuthWelcomeRouterProtocol {
    weak var view: UIViewController?
    private var authDelegate: AuthDelegate
    
    init(
        view: UIViewController? = nil,
        authDelegate: AuthDelegate  = resolve()
    ) {
        self.view = view
        self.authDelegate = authDelegate
    }
    
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
        case .dashboard:
            authDelegate.finishAuthentication()
        }
    }
}
