//
//  ChooseUniversityRouter.swift
//  AppAuthImpl
//
//  Created by Huseyn Hasanov on 26.12.25.
//

import UIKit

enum ChooseUniversityRoute {
    case welcome
    case signIn
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
        case .signIn:
            let vc = SignInBuilder(
                inputData: .init()
            ).build()
            view?.navigationController?.pushViewController(vc, animated: true)
        case .welcome:
            let vc = AuthWelcomeBuilder(
                inputData: .init(name: "Huseyn")
            ).build()
            vc.modalPresentationStyle = .fullScreen
            view?.present(vc, animated: true)
        }
    }
}
