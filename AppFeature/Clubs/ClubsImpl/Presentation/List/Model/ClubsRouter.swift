//
//  ClubsRouter.swift
//  ClubsImpl
//
//  Created by Huseyn Hasanov on 17.01.26.
//

import UIKit

enum ClubsRoute {
}

protocol ClubsRouterProtocol {
    @MainActor
    func navigate(to route: ClubsRoute)
}

final class ClubsRouter: ClubsRouterProtocol {
    weak var view: UIViewController?
    
    @MainActor
    func navigate(to route: ClubsRoute) {
    }
}
