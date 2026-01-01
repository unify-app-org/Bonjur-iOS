//
//  AppTabBarRouter.swift
//  App
//
//  Created by Huseyn Hasanov on 01.01.26.
//  Copyright © 2026 Bonjur. All rights reserved.
//

import UIKit

enum AppTabBarRoute {
}

protocol AppTabBarRouterProtocol {
    @MainActor
    func navigate(to route: AppTabBarRoute)
}

final class AppTabBarRouter: AppTabBarRouterProtocol {
    weak var view: UIViewController?
    
    @MainActor
    func navigate(to route: AppTabBarRoute) {
    }
}
