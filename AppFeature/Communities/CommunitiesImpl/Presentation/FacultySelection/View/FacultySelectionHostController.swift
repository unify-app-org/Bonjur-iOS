//
//  FacultySelectionHostController.swift
//  CommunitiesImpl
//
//  Created by aplle on 3/23/26.
//

import UIKit
import AppFoundation
import AppUIKit

// MARK: - Controller

final class FacultySelectionHostController: UIFeatureController<
    FacultySelectionFeature,
    FacultySelectionView
> {
    override func handleEffect(_ effect: FacultySelectionSideEffect) {
        switch effect {
        case .loading:
            break

        case .showAlert(let title, let subtitle):
            showAlert(title: title, subtitle: subtitle)
        }
    }

    private func showAlert(
        title: String,
        subtitle: String,
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
