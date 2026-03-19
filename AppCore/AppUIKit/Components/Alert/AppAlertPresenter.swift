//
//  AppAlertPresenter.swift
//  AppCore
//
//  Created by aplle on 3/19/26.
//


import SwiftUI
import UIKit

@MainActor
enum AppAlertPresenter {
    private struct Request {
        let sourceID: UUID
        let alert: AppAlert
        let onDismiss: () -> Void
    }

    private static var requests: [UUID: Request] = [:]
    private static var order: [UUID] = []

    private static var overlayWindow: UIWindow?
    private static var hostingController: UIHostingController<AppAlertOverlayView>?

    static func present(
        _ alert: AppAlert,
        sourceID: UUID,
        onDismiss: @escaping () -> Void
    ) {
        let request = Request(
            sourceID: sourceID,
            alert: alert,
            onDismiss: onDismiss
        )

        requests[sourceID] = request
        order.removeAll { $0 == sourceID }
        order.append(sourceID)

        render()
    }

    static func dismiss(sourceID: UUID) {
        requests.removeValue(forKey: sourceID)
        order.removeAll { $0 == sourceID }
        render()
    }

    static func dismissCurrent() {
        guard let request = currentRequest else { return }
        request.onDismiss()
        dismiss(sourceID: request.sourceID)
    }

    private static var currentRequest: Request? {
        order.reversed().compactMap { requests[$0] }.first
    }

    private static func render() {
        guard let request = currentRequest else {
            hostingController = nil
            overlayWindow?.isHidden = true
            overlayWindow?.rootViewController = nil
            overlayWindow = nil
            return
        }

        let rootView = AppAlertOverlayView(
            alert: request.alert,
            dismiss: {
                dismissCurrent()
            }
        )

        if let hostingController {
            hostingController.rootView = rootView
            return
        }

        let window = makeWindow()
        let hostingController = UIHostingController(rootView: rootView)
        hostingController.view.backgroundColor = .clear

        window.rootViewController = hostingController
        window.makeKeyAndVisible()

        self.overlayWindow = window
        self.hostingController = hostingController
    }

    private static func makeWindow() -> UIWindow {
        let window: UIWindow

        if let scene = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first(where: { $0.activationState == .foregroundActive }) {
            window = UIWindow(windowScene: scene)
        } else {
            window = UIWindow(frame: UIScreen.main.bounds)
        }

        window.windowLevel = .alert + 1
        window.backgroundColor = .clear
        return window
    }
}
