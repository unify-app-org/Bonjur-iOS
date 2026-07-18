//
//  ClubsRouter.swift
//  ClubsImpl
//
//  Created by Huseyn Hasanov on 17.01.26.
//

import UIKit

enum ClubsRoute {
    case showDetails(clubId: Int)
    case createClub
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
        case .createClub:
            let vc = ClubCreateBuilder(inputData: .init()).build()
            self.view?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
