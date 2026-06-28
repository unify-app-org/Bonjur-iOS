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
                        title: error?.localizedDescription ?? "Unknown error",
                        subtitle: error?.detail
                    ),
                    actions: {
                        AppAlert.Action(title: "Got it", style: .primary)
                    }
                )
            )
        case .confirmReject(let item):
            AppAlertPresenter.present(
                .init(
                    config: .init(
                        title: "Reject request?",
                        subtitle: "Are you sure you want to reject \(item.requesterName)'s request to join \(item.targetName)?"
                    ),
                    actions: {
                        AppAlert.Action(title: "Cancel", style: .secondary)
                        AppAlert.Action(title: "Reject", style: .destructive) { [weak self] in
                            self?.store.send(.performReject(item))
                        }
                    }
                )
            )
        }
    }
}
