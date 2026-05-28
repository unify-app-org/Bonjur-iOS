import SwiftUI
import UIKit

@MainActor
public enum AppAlertPresenter {

    private static var overlayWindow: UIWindow?
    private static var hostingController: UIHostingController<AppAlertOverlayView>?

    public static func present(
        _ alert: AppAlert,
        onDismiss: (() -> Void)? = nil
    ) {
        let dismiss: (((() -> Void)?) -> Void) = { completion in
            AppAlertPresenter.dismiss(completion: {
                onDismiss?()
                completion?()
            })
        }

        let rootView = AppAlertOverlayView(
            alert: alert,
            dismiss: dismiss,
            isVisible: false
        )

        if let hostingController {
            hostingController.rootView = rootView.visible()
            return
        }

        let window = makeWindow()
        let vc = UIHostingController(rootView: rootView)
        vc.view.backgroundColor = .clear
        window.rootViewController = vc
        window.makeKeyAndVisible()
        overlayWindow = window
        hostingController = vc
        DispatchQueue.main.async {
            hostingController?.rootView = rootView.visible()
        }
    }

    public static func dismiss() {
        dismiss(completion: nil)
    }

    private static func dismiss(completion: (() -> Void)?) {
        guard let hostingController else {
            teardown()
            completion?()
            return
        }

        hostingController.rootView = hostingController.rootView.hidden()
        DispatchQueue.main.asyncAfter(deadline: .now() + AppAlertOverlayView.animationDuration) {
            teardown()
            completion?()
        }
    }

    private static func teardown() {
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
