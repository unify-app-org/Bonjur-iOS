//
//  AppAlertOverlayView.swift
//  AppCore
//
//  Created by aplle on 3/19/26.
//


import SwiftUI

struct AppAlertOverlayView: View {
    let alert: AppAlert
    let dismiss: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.35)
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
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.clear)
        .accessibilityElement(children: .contain)
        .accessibilityAddTraits(.isModal)
    }

    private func handleBackgroundTap() {
        if let onBackgroundTap = alert.config.onBackgroundTap {
            onBackgroundTap(dismiss)
        } else {
            dismiss()
        }
    }
}
