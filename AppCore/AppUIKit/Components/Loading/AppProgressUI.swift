//
//  AppProgressUI.swift
//  AppCore
//
//  Created by Huseyn Hasanov on 19.03.26.
//

import UIKit
import SwiftUI

public final class AppLoadingUI {

    private static var overlayWindow: UIWindow?

    /// True while the overlay is playing its exit animation. Without it a `show()`
    /// landing inside that ~0.2s window was swallowed by the `overlayWindow == nil`
    /// guard — the overlay was still on screen, so nothing was created, and then the
    /// in-flight `animateOut` tore it down and left the screen bare. That is the gap
    /// on the leg back from Microsoft sign-in: the "opening Microsoft" overlay is
    /// dismissed and the "signing in" one is shown a beat later.
    private static var isDismissing = false

    public static func show() {
        Task { @MainActor in
            if let window = overlayWindow,
               let vc = window.rootViewController as? AppLoadingViewController {
                // Already up. If it was on its way out, claim it back instead of
                // letting the pending animation remove it.
                guard isDismissing else { return }
                isDismissing = false
                vc.cancelDismiss()
                return
            }
            let window = makeWindow()
            let vc = AppLoadingViewController()
            window.rootViewController = vc
            window.makeKeyAndVisible()
            overlayWindow = window
            isDismissing = false
            vc.animateIn()
        }
    }

    public static func dismiss() {
        Task { @MainActor in
            guard let window = overlayWindow,
                  let vc = window.rootViewController as? AppLoadingViewController,
                  !isDismissing else { return }
            isDismissing = true
            vc.animateOut {
                // A `show()` arrived mid-animation and took the overlay back.
                guard isDismissing else { return }
                isDismissing = false
                overlayWindow?.isHidden = true
                overlayWindow = nil
            }
        }
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

private final class AppLoadingViewController: UIViewController {

    private let backdropView = UIView()
    private let cardView = UIView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        setupBackdrop()
        setupCard()
        setupIndicator()
    }

    private func setupBackdrop() {
        backdropView.backgroundColor = UIColor.darkGray.withAlphaComponent(0.1)
        backdropView.alpha = 0
        backdropView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backdropView)
        NSLayoutConstraint.activate([
            backdropView.topAnchor.constraint(equalTo: view.topAnchor),
            backdropView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backdropView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backdropView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func setupCard() {
        cardView.backgroundColor = UIColor.systemBackground
        cardView.layer.cornerRadius = 20
        cardView.layer.cornerCurve = .continuous
        cardView.alpha = 0
        cardView.transform = CGAffineTransform(scaleX: 0.88, y: 0.88)
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.08
        cardView.layer.shadowOffset = CGSize(width: 0, height: 4)
        cardView.layer.shadowRadius = 8
        view.addSubview(cardView)
        NSLayoutConstraint.activate([
            cardView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cardView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            cardView.widthAnchor.constraint(equalToConstant: 90),
            cardView.heightAnchor.constraint(equalToConstant: 90)
        ])
    }

    private func setupIndicator() {
        activityIndicator.color = UIColor(.Palette.border)
        activityIndicator.style = .large
        activityIndicator.startAnimating()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: cardView.centerYAnchor)
        ])
    }

    func animateIn() {
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut, .beginFromCurrentState]) {
            self.backdropView.alpha = 1
        }
        UIView.animate(withDuration: 0.3, delay: 0.05, usingSpringWithDamping: 0.72, initialSpringVelocity: 0.5, options: .beginFromCurrentState) { [weak self] in guard let self else { return }
            self.cardView.alpha = 1
            self.cardView.transform = .identity
        } completion: { _ in
        }
    }

    /// Reverses an in-flight `animateOut` when a new `show()` reclaims the overlay.
    func cancelDismiss() {
        activityIndicator.startAnimating()
        animateIn()
    }

    func animateOut(completion: @escaping () -> Void) {
        activityIndicator.stopAnimating()
        UIView.animate(withDuration: 0.18, delay: 0, options: [.curveEaseIn, .beginFromCurrentState]) {
            [weak self] in guard let self else { return }
            self.backdropView.alpha = 0
            self.cardView.alpha = 0
            self.cardView.transform = CGAffineTransform(scaleX: 0.88, y: 0.88)
        } completion: { _ in
            completion()
        }
    }
}
