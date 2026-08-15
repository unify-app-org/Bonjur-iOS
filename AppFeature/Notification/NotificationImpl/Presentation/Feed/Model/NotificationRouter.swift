//
//  NotificationRouter.swift
//  NotificationImpl
//
//  Created by Huseyn Hasanov on 27.06.26.
//

import UIKit
import SwiftUI
import AppFoundation

enum NotificationRoute {
    /// Modal preview of a single notification.
    case preview(NotificationFeedItem)
    /// Pushes the "notif_needs_action".localized screen (join-request tabs).
    case needsAction
}

protocol NotificationRouterProtocol {
    @MainActor
    func navigate(to route: NotificationRoute)
}

final class NotificationRouter: NotificationRouterProtocol {
    weak var view: UIViewController?

    private let deepLinkManager: DeepLinkManagerProtocol

    init(
        view: UIViewController? = nil,
        deepLinkManager: DeepLinkManagerProtocol = resolve()
    ) {
        self.view = view
        self.deepLinkManager = deepLinkManager
    }

    @MainActor
    func navigate(to route: NotificationRoute) {
        switch route {
        case .preview(let item):
            presentPreview(item)
        case .needsAction:
            pushNeedsAction()
        }
    }

    @MainActor
    private func pushNeedsAction() {
        let vc = NeedsActionBuilder(inputData: .init()).build()
        view?.navigationController?.pushViewController(vc, animated: true)
    }

    @MainActor
    private func presentPreview(_ item: NotificationFeedItem) {
        let dismiss: () -> Void = { [weak view] in
            view?.dismiss(animated: true)
        }

        let detail = NotificationDetailView(
            item: item,
            onContinue: { [weak self] in
                self?.openTarget(of: item)
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

    // MARK: - Deep link (preview "notif_continue".localized)
    
    @MainActor
    private func openTarget(of item: NotificationFeedItem) {
        switch item.type.tapDestination {
        case .needsAction:
            view?.dismiss(animated: true) { [weak self] in
                self?.pushNeedsAction()
            }
        case .target:
            let notification = deepLinkNotification(for: item)
            let host = view
            view?.dismiss(animated: true) { [deepLinkManager] in
                guard let notification else { return }
                deepLinkManager.process(
                    notification: notification,
                    context: DeepLinkContext(
                        navigationType: .overCurrentContext(topViewController: host)
                    )
                )
            }
        case .none:
            view?.dismiss(animated: true)
        }
    }
    
    private func deepLinkNotification(for item: NotificationFeedItem) -> DeepLinkNotification? {
        guard let targetId = item.targetId, !targetId.isEmpty else { return nil }

        let identifier: String? = switch item.targetType {
        case .event: "event"
        case .club: "club"
        case .user: "user"
        case .community: "community"
        case .hangout: "hangout"
        case .none: nil
        }
        guard let identifier else { return nil }

        return DeepLinkNotification(
            identifier: identifier,
            action: item.type.apiValue,
            payload: ["id": targetId]
        )
    }
}
