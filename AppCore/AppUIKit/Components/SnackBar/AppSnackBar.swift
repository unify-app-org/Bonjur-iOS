//
//  AppSnackBar.swift
//  AppUIKit
//
//  Created by Huseyn Hasanov on 10.06.26.
//

import SwiftUI
import UIKit

// MARK: - Public API

/// Global toast/snackbar. Presents in its own passthrough window above everything,
/// so it can be called from anywhere (view models, routers, etc.) without a view
/// reference and stays visible across navigation.
///
///     AppSnackBar.show(title: "Event created successfully",
///                      subtitle: "Football events · now active",
///                      style: .success)
public enum AppSnackBar {

    public enum Style {
        case success
        case warning
        case error
    }

    public static func show(
        title: String,
        subtitle: String = "",
        style: Style = .success
    ) {
        DispatchQueue.main.async {
            AppSnackBarPresenter.shared.show(
                title: title,
                subtitle: subtitle,
                style: style
            )
        }
    }
}

// MARK: - Style tokens

extension AppSnackBar.Style {

    var backgroundColor: Color {
        switch self {
        case .success: Color.Palette.greenLight
        case .warning: Color.Palette.cardBgOrange.opacity(0.18)
        case .error: Color.Palette.destructiveRed.opacity(0.12)
        }
    }

    var iconColor: Color {
        switch self {
        case .success: Color.Palette.green900
        case .warning: Color.Palette.cardBgOrange
        case .error: Color.Palette.destructiveRed
        }
    }

    var iconSystemName: String {
        switch self {
        case .success: "checkmark"
        case .warning: "exclamationmark"
        case .error: "xmark"
        }
    }
}

// MARK: - Card view

struct AppSnackBarView: View {

    let title: String
    let subtitle: String
    let style: AppSnackBar.Style

    var body: some View {
        HStack(spacing: 12) {
            iconView
            textView
            Spacer(minLength: 0)
        }
        .padding(16)
        .background(style.backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 2)
    }

    private var iconView: some View {
        ZStack {
            Circle()
                .fill(style.iconColor)
                .frame(width: 44, height: 44)
            Image(systemName: style.iconSystemName)
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(Color.Palette.white)
        }
    }

    private var textView: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(Font.Typography.HeadingMd.bold)
                .foregroundStyle(Color.Palette.black)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
            if !subtitle.isEmpty {
                Text(subtitle)
                    .font(Font.Typography.TextMd.regular)
                    .foregroundStyle(Color.Palette.blackMedium)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Full-screen container (bottom aligned)

private struct AppSnackBarContainer: View {

    let title: String
    let subtitle: String
    let style: AppSnackBar.Style

    var body: some View {
        VStack {
            Spacer(minLength: 0)
            AppSnackBarView(
                title: title,
                subtitle: subtitle,
                style: style
            )
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(.keyboard)
    }
}

// MARK: - Passthrough window (non-blocking)

private final class PassthroughWindow: UIWindow {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hit = super.hitTest(point, with: event)
        // Toast is non-interactive: let taps on the empty area fall through to the app.
        return hit === rootViewController?.view ? nil : hit
    }
}

// MARK: - Presenter (own window + animation)

final class AppSnackBarPresenter {

    static let shared = AppSnackBarPresenter()

    private var window: PassthroughWindow?
    private var hideWorkItem: DispatchWorkItem?

    private let visibleDuration: TimeInterval = 2.5
    private let offscreenOffset: CGFloat = 60

    private init() {}

    func show(
        title: String,
        subtitle: String,
        style: AppSnackBar.Style
    ) {
        guard let scene = activeScene else { return }

        // Drop any currently visible snackbar instantly.
        dismissImmediately()

        let host = UIHostingController(
            rootView: AppSnackBarContainer(
                title: title,
                subtitle: subtitle,
                style: style
            )
        )
        host.view.backgroundColor = .clear

        let window = PassthroughWindow(windowScene: scene)
        window.windowLevel = .alert + 1
        window.backgroundColor = .clear
        window.rootViewController = host
        window.isHidden = false
        self.window = window

        let content = host.view!
        content.alpha = 0
        content.transform = CGAffineTransform(translationX: 0, y: offscreenOffset)

        UIView.animate(
            withDuration: 0.6,
            delay: 0.05,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0.6,
            options: [.curveEaseInOut]
        ) {
            content.alpha = 1
            content.transform = .identity
        }

        let work = DispatchWorkItem { [weak self] in
            self?.hide()
        }
        hideWorkItem = work
        DispatchQueue.main.asyncAfter(
            deadline: .now() + visibleDuration,
            execute: work
        )
    }

    private func hide() {
        hideWorkItem?.cancel()
        hideWorkItem = nil
        guard let window, let content = window.rootViewController?.view else {
            dismissImmediately()
            return
        }

        UIView.animate(
            withDuration: 0.25,
            delay: 0,
            options: [.curveEaseOut]
        ) {
            content.alpha = 0
            content.transform = CGAffineTransform(
                translationX: 0,
                y: self.offscreenOffset
            )
        } completion: { [weak self] _ in
            guard let self, self.window === window else { return }
            self.dismissImmediately()
        }
    }

    private func dismissImmediately() {
        hideWorkItem?.cancel()
        hideWorkItem = nil
        window?.isHidden = true
        window?.rootViewController = nil
        window = nil
    }

    private var activeScene: UIWindowScene? {
        let scenes = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
        return scenes.first { $0.activationState == .foregroundActive }
            ?? scenes.first
    }
}
