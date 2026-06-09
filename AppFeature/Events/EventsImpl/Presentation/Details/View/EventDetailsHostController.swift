//
//  EventDetailsHostController.swift
//  EventsImpl
//
//  Created by Huseyn Hasanov on 01.02.26.
//

import UIKit
import AppUIKit
import AppFoundation

// MARK: - Controller

final class EventDetailsHostController: UIFeatureController<
    EventDetailsFeature,
    EventDetailsView
> {
    override func viewDidLoad() {
        super.viewDidLoad()
        hidesBottomBarWhenPushed = true
    }

    override func handleEffect(_ effect: EventDetailsSideEffect) {
        switch effect {
        case .loading(let isLoading):
            if isLoading {
                AppLoadingUI.show()
            } else {
                AppLoadingUI.dismiss()
            }
        case .error(let error):
            showAlert(
                title: error?.localizedDescription ?? "Something went wrong",
                subtitle: error?.detail
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
