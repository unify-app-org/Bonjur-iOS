//
//  ClubCreateRouter.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 21.02.26.
//

import UIKit

enum ClubCreateRoute {
}

protocol ClubCreateRouterProtocol {
    @MainActor
    func navigate(to route: ClubCreateRoute)
}

final class ClubCreateRouter: ClubCreateRouterProtocol {
    weak var view: UIViewController?
    
    @MainActor
    func navigate(to route: ClubCreateRoute) {
    }
}
