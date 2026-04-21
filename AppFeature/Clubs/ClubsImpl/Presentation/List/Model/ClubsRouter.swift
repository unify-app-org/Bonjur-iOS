//
//  ClubsRouter.swift
//  ClubsImpl
//
//  Created by Huseyn Hasanov on 17.01.26.
//

import UIKit

enum ClubsRoute {
    case showDetails(clubId: Int)
}

protocol ClubsRouterProtocol {
    @MainActor
    func navigate(to route: ClubsRoute)
}

final class ClubsRouter: ClubsRouterProtocol {
    weak var view: UIViewController?
    
    @MainActor
    func navigate(to route: ClubsRoute) {
        switch route {
        case .showDetails(let clubId):
            let vc = ClubDetailsBuilder(inputData: .init(clubId: clubId)).build()
            self.view?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
