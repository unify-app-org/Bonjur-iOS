//
//  HangoutListRoute.swift
//  HangoutsImpl
//
//  Created by Huseyn Hasanov on 22.01.26.
//

import UIKit

enum HangoutListRoute {
}

protocol HangoutListRouterProtocol {
    @MainActor
    func navigate(to route: HangoutListRoute)
}

final class HangoutListRouter: HangoutListRouterProtocol {
    weak var view: UIViewController?
    
    @MainActor
    func navigate(to route: HangoutListRoute) {
    }
}
