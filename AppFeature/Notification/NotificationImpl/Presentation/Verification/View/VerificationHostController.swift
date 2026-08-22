//
//  VerificationHostController.swift
//  NotificationImpl
//
//  Created by Huseyn Hasanov on 28.06.26.
//

import UIKit
import AppUIKit
import AppFoundation
import AppNetwork

final class VerificationHostController: UIFeatureController<
    VerificationFeature,
    VerificationView
> {
    override func handleEffect(_ effect: VerificationSideEffect) {
        switch effect {
        case .error(let error):
            AppAlertPresenter.present(
                .init(
                    config: .init(
                        title: APIError.popupTitle,
                        subtitle: error.popupSubtitle
                    ),
                    actions: {
                        AppAlert.Action(title: "common_got_it".localized, style: .primary)
                    }
                )
            )
        }
    }
}
