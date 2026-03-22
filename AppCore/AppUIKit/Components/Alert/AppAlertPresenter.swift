import SwiftUI
import UIKit

@MainActor
public enum AppAlertPresenter {

    private static var overlayWindow: UIWindow?
    private static var hostingController: UIHostingController<AppAlertOverlayView>?

    public static func present(
        _ alert: AppAlert,
        onDismiss: @escaping () -> Void
    ) {
        let rootView = AppAlertOverlayView(alert: alert, dismiss: onDismiss)

        if let hostingController {
            hostingController.rootView = rootView
            return
        }

        let window = makeWindow()
        let vc = UIHostingController(rootView: rootView)
        vc.view.backgroundColor = .clear
        window.rootViewController = vc
        window.makeKeyAndVisible()
        overlayWindow = window
        hostingController = vc
    }

    public static func dismiss() {
        hostingController = nil
        overlayWindow?.isHidden = true
        overlayWindow?.rootViewController = nil
        overlayWindow = nil
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
