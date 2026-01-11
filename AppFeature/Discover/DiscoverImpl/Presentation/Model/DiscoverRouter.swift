//
//  DiscoverRouter.swift
//  DiscoverImpl
//
//  Created by Huseyn Hasanov on 11.01.26.
//

import UIKit

enum DiscoverRoute {
}

protocol DiscoverRouterProtocol {
    @MainActor
    func navigate(to route: DiscoverRoute)
}

final class DiscoverRouter: DiscoverRouterProtocol {
    weak var view: UIViewController?
    
    @MainActor
    func navigate(to route: DiscoverRoute) {
    }
}
