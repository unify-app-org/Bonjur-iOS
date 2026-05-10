//
//  AuthOptionalInfoHostController.swift
//  AppAuthImpl
//
//  Created by Huseyn Hasanov on 26.12.25.
//

import UIKit
import AppFoundation
import AppUIKit

// MARK: - Controller

final class AuthOptionalInfoHostController: UIFeatureController<
    AuthOptionalInfoFeature,
    AuthOptionalInfoView
> {
    override func handleEffect(_ effect: AuthOptionalInfoSideEffect) {
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
