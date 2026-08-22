//
//  ClubDetailsHostController.swift
//  AppAuth
//
//  Created by Huseyn Hasanov on 29.01.26.
//

import UIKit
import AppUIKit
import AppFoundation
import AppNetwork

// MARK: - Controller

final class ClubDetailsHostController: UIFeatureController<
    ClubDetailsFeature,
    ClubDetailsView
> {
    override func viewDidLoad() {
        super.viewDidLoad()
        hidesBottomBarWhenPushed = true
    }

    override func handleEffect(_ effect: ClubDetailsSideEffect) {
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
