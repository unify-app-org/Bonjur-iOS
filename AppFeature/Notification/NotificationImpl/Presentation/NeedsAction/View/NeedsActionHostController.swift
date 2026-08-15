//
//  NeedsActionHostController.swift
//  NotificationImpl
//
//  Created by Huseyn Hasanov on 28.06.26.
//

import UIKit
import AppUIKit
import AppFoundation

final class NeedsActionHostController: UIFeatureController<
    NeedsActionFeature,
    NeedsActionView
> {
    override func handleEffect(_ effect: NeedsActionSideEffect) {
        switch effect {
        case .error(let error):
            AppAlertPresenter.present(
                .init(
                    config: .init(
                        title: error?.localizedDescription ?? "common_unknown_error".localized,
                        subtitle: error?.detail
                    ),
                    actions: {
                        AppAlert.Action(title: "common_got_it".localized, style: .primary)
                    }
                )
            )
        case .confirmReject(let item):
            AppAlertPresenter.present(
                .init(
                    config: .init(
                        title: "notif_reject_request".localized,
                        subtitle: "Are you sure you want to reject \(item.requesterName)'s request to join \(item.targetName)?"
                    ),
                    actions: {
                        AppAlert.Action(title: "common_cancel".localized, style: .secondary)
                        AppAlert.Action(title: "notif_reject".localized, style: .destructive) { [weak self] in
                            self?.store.send(.performReject(item))
                        }
                    }
                )
            )
        }
    }
}
