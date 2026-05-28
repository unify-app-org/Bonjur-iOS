//
//  AppAlertOverlayView.swift
//  AppCore
//
//  Created by aplle on 3/19/26.
//


import SwiftUI

struct AppAlertOverlayView: View {
    static let animationDuration: TimeInterval = 0.2

    let alert: AppAlert
    let dismiss: (((() -> Void)?) -> Void)
    let isVisible: Bool

    var body: some View {
        ZStack {
            Color.black.opacity(isVisible ? 0.35 : 0)
                .ignoresSafeArea()
                .accessibilityHidden(true)
                .onTapGesture {
                    handleBackgroundTap()
                }

            AppAlertView(
                alert: alert,
                dismiss: dismiss
            )
            .padding(.horizontal, 24)
        }
        .opacity(isVisible ? 1 : 0)
        .animation(.easeInOut(duration: Self.animationDuration), value: isVisible)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.clear)
        .allowsHitTesting(isVisible)
        .accessibilityElement(children: .contain)
        .accessibilityAddTraits(.isModal)
    }

    private func handleBackgroundTap() {
        dismiss(alert.config.onBackgroundTap)
    }
}

extension AppAlertOverlayView {
    func visible() -> AppAlertOverlayView {
        AppAlertOverlayView(alert: alert, dismiss: dismiss, isVisible: true)
    }

    func hidden() -> AppAlertOverlayView {
        AppAlertOverlayView(alert: alert, dismiss: dismiss, isVisible: false)
    }
}
