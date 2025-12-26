//
//  AuthOptionalInfoRouter.swift
//  AppAuthImpl
//
//  Created by Huseyn Hasanov on 26.12.25.
//

import UIKit

enum AuthOptionalInfoRoute {
}

protocol AuthOptionalInfoRouterProtocol {
    @MainActor
    func navigate(to route: AuthOptionalInfoRoute)
}

final class AuthOptionalInfoRouter: AuthOptionalInfoRouterProtocol {
    weak var view: UIViewController?
    
    @MainActor
    func navigate(to route: AuthOptionalInfoRoute) {
    }
}
