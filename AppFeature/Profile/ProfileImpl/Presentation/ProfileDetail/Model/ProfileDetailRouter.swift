//
//  ProfileDetailRouter.swift
//  ProfileImpl
//
//  Created by Huseyn Hasanov on 04.02.26.
//

import UIKit

enum ProfileDetailRoute {
}

protocol ProfileDetailRouterProtocol {
    @MainActor
    func navigate(to route: ProfileDetailRoute)
}

final class ProfileDetailRouter: ProfileDetailRouterProtocol {
    weak var view: UIViewController?
    
    @MainActor
    func navigate(to route: ProfileDetailRoute) {
    }
}
