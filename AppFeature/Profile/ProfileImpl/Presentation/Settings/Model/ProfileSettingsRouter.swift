//
//  ProfileSettingsRouter.swift
//  ProfileImpl
//
//  Created by Nahid Askerli on 26.03.26.
//

import UIKit
import SwiftUI
import AppFoundation
import AppUIKit
import Profile

enum ProfileSettingsRoute {
    case back
    case language
    case helpCenter
    case termsAndConditions
    case deleteAccount(onConfirm: () -> Void)
    case logout
    case finishSession
}

protocol ProfileSettingsRouterProtocol {
    @MainActor
    func navigate(to route: ProfileSettingsRoute)
}

final class ProfileSettingsRouter: ProfileSettingsRouterProtocol {
    weak var view: UIViewController?
    private var delegate: ProfileDelegate
    
    init(
        view: UIViewController? = nil,
        delegate: ProfileDelegate = resolve()
    ) {
        self.view = view
        self.delegate = delegate
    }
    
    @MainActor
    func navigate(to route: ProfileSettingsRoute) {
        switch route {
        case .back:
            break
        case .language:
            presentLanguagePicker()
        case .helpCenter:
            break
        case .termsAndConditions:
            break
        case .deleteAccount(let onConfirm):
            showConfirmationAlert(
                title: "settings_delete_title".localized,
                subtitle: "settings_delete_subtitle".localized,
                confirmTitle: "settings_delete_confirm".localized,
                confirmStyle: .destructive,
                onConfirm: onConfirm
            )
        case .logout:
            showConfirmationAlert(
                title: "settings_logout_title".localized,
                subtitle: "settings_logout_subtitle".localized,
                confirmTitle: "settings_logout_confirm".localized,
                confirmStyle: .destructive
            ) { [weak self] in
                self?.delegate.logout()
            }
        case .finishSession:
            delegate.logout()
        }
    }
    
    @MainActor
    private func presentLanguagePicker() {
        let localization: AppLocalizationProtocol = resolve()
        let picker = LanguageSelectionView { [weak view] code in
            localization.setLanguage(code)
            view?.dismiss(animated: true)
        }
        let host = UIHostingController(rootView: picker)
        if let sheet = host.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 24
        }
        view?.present(host, animated: true)
    }

    @MainActor
    private func showConfirmationAlert(
        title: String,
        subtitle: String,
        confirmTitle: String,
        confirmStyle: AppAlert.Action.Style,
        onConfirm: @escaping () -> Void
    ) {
        AppAlertPresenter.present(
            .init(
                config: .init(
                    title: title,
                    subtitle: subtitle
                ),
                actions: {
                    AppAlert.Action(
                        title: "common_cancel".localized,
                        style: .primary
                    )
                    
                    AppAlert.Action(
                        title: confirmTitle,
                        style: confirmStyle,
                        handler: onConfirm
                    )
                }
            )
        )
    }
}
