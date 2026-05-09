//
//  ChooseUniversityRouter.swift
//  AppAuthImpl
//
//  Created by Huseyn Hasanov on 26.12.25.
//

import UIKit

enum ChooseUniversityRoute {
    case signIn(SignInInputData)
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
        }
    }
}
