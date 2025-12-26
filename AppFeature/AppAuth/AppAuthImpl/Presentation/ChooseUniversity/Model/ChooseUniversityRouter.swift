//
//  ChooseUniversityRouter.swift
//  AppAuthImpl
//
//  Created by Huseyn Hasanov on 26.12.25.
//

import UIKit

enum ChooseUniversityRoute {
    case welcome
}

protocol ChooseUniversityRouterProtocol {
    @MainActor
    func navigate(to route: ChooseUniversityRoute)
}

final class ChooseUniversityRouter: ChooseUniversityRouterProtocol {
    weak var view: UIViewController?
    
    @MainActor
    func navigate(to route: ChooseUniversityRoute) {
        switch route {
        case .welcome:
            let vc = AuthWelcomeBuilder(
                inputData: .init(name: "Huseyn")
            ).build()
            vc.modalPresentationStyle = .fullScreen
            view?.present(vc, animated: true)
        }
    }
}
