//
//  OnboardingRouter.swift
//  AppAuth
//
//  Created by Huseyn Hasanov on 23.12.25.
//

import UIKit

enum OnboardingRoute {
    case chooseUniversity
}

protocol OnboardingRouterProtocol {
    @MainActor
    func navigate(to route: OnboardingRoute)
}

final class OnboardingRouter: OnboardingRouterProtocol {
    weak var view: UIViewController?
    
    @MainActor
    func navigate(to route: OnboardingRoute) {
        switch route {
        case .chooseUniversity:
            let vc = ChooseUniversityBuilder(
                inputData: .init()
            ).build()
            self.view?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
