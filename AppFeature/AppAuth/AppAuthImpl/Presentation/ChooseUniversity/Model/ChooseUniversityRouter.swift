//
//  ChooseUniversityRouter.swift
//  AppAuthImpl
//
//  Created by Huseyn Hasanov on 26.12.25.
//

import UIKit
import AppUIKit
import AppFoundation

enum ChooseUniversityRoute {
    case signIn(SignInInputData)
    case terms
    case privacy
}

protocol ChooseUniversityRouterProtocol {
    @MainActor
    func navigate(to route: ChooseUniversityRoute)
}

final class ChooseUniversityRouter: ChooseUniversityRouterProtocol {
    weak var view: UIViewController?
    private let signInFlowCoordinator = SignInFlowCoordinator()

    @MainActor
    func navigate(to route: ChooseUniversityRoute) {
        switch route {
        case .signIn(let inputData):
            guard let view else { return }
            signInFlowCoordinator.start(from: view, with: inputData)
        case .terms:
            let controller = AppWebViewController(
                url: LegalLinks.termsURL,
                title: "auth_terms_link".localized
            )
            view?.navigationController?.pushViewController(controller, animated: true)
        case .privacy:
            let controller = AppWebViewController(
                url: LegalLinks.privacyURL,
                title: "auth_privacy_title".localized
            )
            view?.navigationController?.pushViewController(controller, animated: true)
        }
    }
}
