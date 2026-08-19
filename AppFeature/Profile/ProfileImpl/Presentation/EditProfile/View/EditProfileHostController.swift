//
//  EditProfileHostController.swift
//  ProfileImpl
//
//  Created by Huseyn Hasanov on 11.05.26.
//

import UIKit
import AppUIKit
import AppFoundation

// MARK: - Controller

final class EditProfileHostController: UIFeatureController<
    EditProfileFeature,
    EditProfileView
> {
    override func handleEffect(_ effect: EditProfileSideEffect) {
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
        buttonTitle: String = "common_got_it".localized
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
