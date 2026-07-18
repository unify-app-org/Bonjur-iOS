//
//  HangoutCreateHostController.swift
//  AppFeature
//
//  Created by Codex on 30.05.26.
//

import AppFoundation
import AppUIKit

final class HangoutCreateHostController: UIFeatureController<
    HangoutCreateFeature,
    HangoutCreateView
> {
    override func viewDidLoad() {
        super.viewDidLoad()
        hidesBottomBarWhenPushed = true
    }
    override func handleEffect(_ effect: HangoutCreateSideEffect) {
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
