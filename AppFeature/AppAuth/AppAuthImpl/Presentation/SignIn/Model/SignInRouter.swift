//
//  SignInRouter.swift
//  AppAuthImpl
//
//  Created by Huseyn Hasanov on 06.01.26.
//

import UIKit

enum SignInRoute {
    case home
}

protocol SignInRouterProtocol {
    @MainActor
    func navigate(to route: SignInRoute)
}

final class SignInRouter: SignInRouterProtocol {
    weak var view: UIViewController?
    private var authDelegate: AuthDelegate
    
    init(
        view: UIViewController? = nil,
        authDelegate: AuthDelegate = resolve()
    ) {
        self.view = view
        self.authDelegate = authDelegate
    }
    
    @MainActor
    func navigate(to route: SignInRoute) {
        switch route {
        case .home:
            authDelegate.finishAuthentication()
        }
    }
}
