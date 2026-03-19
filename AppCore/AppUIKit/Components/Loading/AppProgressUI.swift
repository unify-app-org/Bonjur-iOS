//
//  AppProgressUI.swift
//  AppCore
//
//  Created by Huseyn Hasanov on 19.03.26.
//

import UIKit

public final class AppLoadingUI {

    private static var overlayWindow: UIWindow?

    public static func show() {
        Task { @MainActor in
            guard overlayWindow == nil else { return }
            let window = makeWindow()
            let vc = AppLoadingViewController()
            window.rootViewController = vc
            window.makeKeyAndVisible()
            overlayWindow = window
            vc.animateIn()
        }
    }

    public static func dismiss() {
        Task { @MainActor in
            guard let window = overlayWindow,
                  let vc = window.rootViewController as? AppLoadingViewController else { return }
            vc.animateOut {
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
        cardView.layer.shadowRadius = 16
        view.addSubview(cardView)
        NSLayoutConstraint.activate([
            cardView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cardView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            cardView.widthAnchor.constraint(equalToConstant: 80),
            cardView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }

    private func setupIndicator() {
        activityIndicator.color = .label
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
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut) {
            self.backdropView.alpha = 1
        }
        UIView.animate(withDuration: 0.3, delay: 0.05, usingSpringWithDamping: 0.72, initialSpringVelocity: 0.5) { [weak self] in guard let self else { return }
            self.cardView.alpha = 1
            self.cardView.transform = .identity
        } completion: { _ in
        }
    }

    func animateOut(completion: @escaping () -> Void) {
        activityIndicator.stopAnimating()
        UIView.animate(withDuration: 0.18, delay: 0, options: .curveEaseIn) {
            [weak self] in guard let self else { return }
            self.backdropView.alpha = 0
            self.cardView.alpha = 0
            self.cardView.transform = CGAffineTransform(scaleX: 0.88, y: 0.88)
        } completion: { _ in
            completion()
        }
    }
}
