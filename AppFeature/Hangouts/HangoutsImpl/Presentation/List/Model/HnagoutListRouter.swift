//
//  HangoutListRoute.swift
//  HangoutsImpl
//
//  Created by Huseyn Hasanov on 22.01.26.
//

import UIKit

enum HangoutListRoute {
    case details(hangoutId: String)
}

protocol HangoutListRouterProtocol {
    @MainActor
    func navigate(to route: HangoutListRoute)
}

final class HangoutListRouter: HangoutListRouterProtocol {
    weak var view: UIViewController?
    
    @MainActor
    func navigate(to route: HangoutListRoute) {
        switch route {
        case .details(let hangoutId):
            let vc = HangoutDetailsBuilder(
                inputData: .init(
                    hangoutId: hangoutId
                )
            ).build()
            view?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
