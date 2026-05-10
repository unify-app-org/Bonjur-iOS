//
//  SignInHostController.swift
//  AppAuthImpl
//
//  Created by Huseyn Hasanov on 06.01.26.
//

import UIKit
import AppFoundation
import AppUIKit

// MARK: - Controller

final class SignInHostController: UIFeatureController<
    SignInFeature,
    SignInView
> {
    override func handleEffect(_ effect: SignInSideEffect) {
        switch effect {
        case .loading(let isLoading):
            if isLoading {
                AppLoadingUI.show()
            } else {
                AppLoadingUI.dismiss()
            }
        case .error(let title, let subtitle):
            showAlert(title: title, subtitle: subtitle)
        }
    }
    
    private func showAlert(
        title: String,
        subtitle: String?,
        buttonTitle: String = "Got it"
    ) {
        AppAlertPresenter.present(
            .init(
                config: .init(
                    title: title,
                    subtitle: subtitle
                ),
                actions: {
                    AppAlert.Action(
                        title: buttonTitle,
                        style: .primary
                    )
                }
            )
        )
    }
}
