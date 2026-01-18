//
//  DiscoverRouter.swift
//  DiscoverImpl
//
//  Created by Huseyn Hasanov on 11.01.26.
//

import UIKit

enum DiscoverRoute {
    case viewAllClubs
}

protocol DiscoverRouterProtocol {
    @MainActor
    func navigate(to route: DiscoverRoute)
}

final class DiscoverRouter: DiscoverRouterProtocol {
    weak var view: UIViewController?
    private var deleagete: DiscoverDeleagete
    
    init(
        view: UIViewController? = nil,
        deleagete: DiscoverDeleagete = resolve()
    ) {
        self.view = view
        self.deleagete = deleagete
    }
    
    @MainActor
    func navigate(to route: DiscoverRoute) {
        switch route {
        case .viewAllClubs:
            deleagete.viewAllClubs()
        }
    }
}
