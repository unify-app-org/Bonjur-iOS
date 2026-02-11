//
//  AuthOptionalInfoRouter.swift
//  AppAuthImpl
//
//  Created by Huseyn Hasanov on 26.12.25.
//

import UIKit

enum AuthOptionalInfoRoute {
    case skip
}

protocol AuthOptionalInfoRouterProtocol {
    @MainActor
    func navigate(to route: AuthOptionalInfoRoute)
}

final class AuthOptionalInfoRouter: AuthOptionalInfoRouterProtocol {
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
    func navigate(to route: AuthOptionalInfoRoute) {
        switch route {
        case .skip:
            authDelegate.finishAuthentication()
        }
    }
}
