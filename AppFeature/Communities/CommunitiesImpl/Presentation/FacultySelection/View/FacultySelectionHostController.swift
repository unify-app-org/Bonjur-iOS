//
//  FacultySelectionHostController.swift
//  CommunitiesImpl
//
//  Created by aplle on 3/23/26.
//

// MARK: - Controller
import UIKit
import AppFoundation
import AppUIKit

final class FacultySelectionHostController: UIFeatureController<
    FacultySelectionFeature,
    FacultySelectionView
> {
    override func handleEffect(_ effect: FacultySelectionSideEffect) {
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
