//
//  AppAlertModifier.swift
//  AppCore
//
//  Created by aplle on 3/18/26.
//


import SwiftUI

private struct AppAlertModifier: ViewModifier {
    @Binding private var isPresented: Bool
    private let alert: AppAlert

    init(
        isPresented: Binding<Bool>,
        alert: AppAlert
    ) {
        self._isPresented = isPresented
        self.alert = alert
    }

    func body(content: Content) -> some View {
        content
            .overlay {
                if isPresented {
                    ZStack {
                        Color.black.opacity(0.35)
                            .ignoresSafeArea()
                            .onTapGesture {
                                handleBackgroundTap()
                            }

                        AppAlertView(
                            alert: alert,
                            dismiss: dismiss
                        )
                        .transition(.scale(scale: 0.96).combined(with: .opacity))
                    }
                }
            }
            .animation(.easeInOut(duration: 0.15), value: isPresented)
    }

    private func dismiss() {
        withAnimation {
            isPresented = false
        }
    }

    private func handleBackgroundTap() {
        if let onBackgroundTap = alert.config.onBackgroundTap {
            onBackgroundTap(dismiss)
        } else {
            dismiss()
        }
    }
}

public extension View {
    func appAlert(
        isPresented: Binding<Bool>,
        alert: AppAlert
    ) -> some View {
        modifier(
            AppAlertModifier(
                isPresented: isPresented,
                alert: alert
            )
        )
    }
}
