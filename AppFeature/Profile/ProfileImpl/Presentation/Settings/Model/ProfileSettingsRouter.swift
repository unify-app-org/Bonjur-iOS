//
//  ProfileSettingsRouter.swift
//  ProfileImpl
//
//  Created by Nahid Askerli on 26.03.26.
//

import UIKit
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
            break
        case .helpCenter:
            break
        case .termsAndConditions:
            break
        case .deleteAccount(let onConfirm):
            showConfirmationAlert(
                title: "Delete account?",
                subtitle: "Are you sure you want to delete your account? This action cannot be undone.",
                confirmTitle: "Delete",
                confirmStyle: .destructive,
                onConfirm: onConfirm
            )
        case .logout:
            showConfirmationAlert(
                title: "Log out?",
                subtitle: "Are you sure you want to log out?",
                confirmTitle: "Log out",
                confirmStyle: .destructive
            ) { [weak self] in
                self?.delegate.logout()
            }
        case .finishSession:
            delegate.logout()
        }
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
                        title: "Cancel",
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
