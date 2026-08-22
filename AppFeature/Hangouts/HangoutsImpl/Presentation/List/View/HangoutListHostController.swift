//
//  HangoutListHostController.swift
//  HangoutsImpl
//
//  Created by Huseyn Hasanov on 22.01.26.
//

import UIKit
import AppFoundation
import AppUIKit
import AppNetwork

// MARK: - Controller

final class HangoutListHostController: UIFeatureController<
    HangoutListFeature,
    HangoutListView
> {
    override func handleEffect(_ effect: HangoutListSideEffect) {
        switch effect {
        case .loading(let isLoading):
            if isLoading {
                AppLoadingUI.show()
            } else {
                AppLoadingUI.dismiss()
            }
        case .error(let error):
            showAlert(
                title: APIError.popupTitle,
                subtitle: error.popupSubtitle
            )
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
