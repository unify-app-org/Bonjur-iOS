//
//  NotificationRouter.swift
//  NotificationImpl
//
//  Created by Huseyn Hasanov on 27.06.26.
//

import UIKit
import SwiftUI

enum NotificationRoute {
    /// Modal preview of a single notification.
    case preview(NotificationFeedItem)
}

protocol NotificationRouterProtocol {
    @MainActor
    func navigate(to route: NotificationRoute)
}

final class NotificationRouter: NotificationRouterProtocol {
    weak var view: UIViewController?

    init(view: UIViewController? = nil) {
        self.view = view
    }

    @MainActor
    func navigate(to route: NotificationRoute) {
        switch route {
        case .preview(let item):
            presentPreview(item)
        }
    }

    @MainActor
    private func presentPreview(_ item: NotificationFeedItem) {
        // Dismissing the presenter tears down the presented modal.
        let dismiss: () -> Void = { [weak view] in
            view?.dismiss(animated: true)
        }

        let detail = NotificationDetailView(
            item: item,
            onContinue: {
                // TODO: deep-link to item.targetType/targetId, then dismiss.
                dismiss()
            },
            onClose: dismiss
        )

        let host = UIHostingController(rootView: detail)
        let back = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            primaryAction: UIAction { _ in dismiss() }
        )
        back.tintColor = .label
        host.navigationItem.leftBarButtonItem = back

        let nav = UINavigationController(rootViewController: host)
        nav.modalPresentationStyle = .pageSheet
        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.prefersGrabberVisible = true
        }
        view?.present(nav, animated: true)
    }
}
