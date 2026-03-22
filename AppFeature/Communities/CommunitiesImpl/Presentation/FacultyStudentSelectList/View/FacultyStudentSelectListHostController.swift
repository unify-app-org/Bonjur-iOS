//
//  FacultyStudentSelectListHostController.swift
//  CommunitiesImpl
//
//  Created by aplle on 3/22/26.
//

import UIKit
import AppFoundation
import AppUIKit

// MARK: - Controller

final class FacultyStudentSelectListHostController: UIFeatureController<
    FacultyStudentSelectListFeature,
    FacultyStudentSelectListView
> {
    override func handleEffect(_ effect: FacultyStudentSelectListSideEffect) {
        switch effect {
        case .loading(let isLoading):
            if isLoading {
            } else {
            }
        case .capacityLimitReached(overflowCount: let overflowCount):
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
                    AppAlert.Action(title: "Got it", style: .primary) { dismiss in
                        dismiss()
                    }
                }
            )
        ) {
            AppAlertPresenter.dismiss()
        }
    }
}
