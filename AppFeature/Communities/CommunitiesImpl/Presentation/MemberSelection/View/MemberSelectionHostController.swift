//
//  MemberSelectionHostController.swift
//  CommunitiesImpl
//
//  Created by aplle on 3/23/26.
//

import UIKit
import AppFoundation

// MARK: - Controller
import UIKit
import AppFoundation
import AppUIKit

final class MemberSelectionHostController: UIFeatureController<
    MemberSelectionFeature,
    MemberSelectionView
> {
    override func handleEffect(_ effect: MemberSelectionSideEffect) {
        switch effect {
        case .loading:
            break

        case .capacityLimitReached(let overflowCount):
            showOverflowAlert(overflowCount: overflowCount)
        }
    }

    private func showOverflowAlert(overflowCount: Int) {
        AppAlertPresenter.present(
            .init(
                config: .init(
                    title: "Capacity limit reached",
                    subtitle: "Remove \(overflowCount) member\(overflowCount == 1 ? "" : "s") to continue."
                ),
                actions: {
                    AppAlert.Action(
                        title: "Got it",
                        style: .primary
                    ) { dismiss in
                        dismiss()
                    }
                }
            )
        ) {
            AppAlertPresenter.dismiss()
        }
    }
}
