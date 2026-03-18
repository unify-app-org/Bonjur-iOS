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
            .accessibilityHidden(isPresented)
            .overlay {
                if isPresented {
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
                        .accessibilityElement(children: .contain)
                        .accessibilityAddTraits(.isModal)
                        .transition(.scale(scale: 0.96).combined(with: .opacity))
                    }
                    .frame(maxWidth: .infinity,maxHeight: .infinity)
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


#Preview("Primary + Secondary") {
    ZStack{
        Color.white.ignoresSafeArea()
    }
    .appAlert(isPresented: .constant(true), alert: .init(
        config: .init(
            title: "Join this club?",
            subtitle: "You will get access to members, events, and club updates after joining."
        ),
        actions: {
            AppAlert.Action(
                title: "Cancel",
                style: .secondary
            ) { dismiss in
                dismiss()
            }

            AppAlert.Action(
                title: "Join",
                style: .primary
            ) { dismiss in
                dismiss()
            }
        }
    ) )
   
}

#Preview("Destructive + Primary") {
    ZStack{
        Color.white.ignoresSafeArea()
    }
    .appAlert(isPresented: .constant(true), alert:.init(
        config: .init(
            title: "Are you sure you want to exit this club?",
            subtitle: "If you leave this club, you will lose access to its events and members. You can join again only if the owner approves."
        ),
        actions: {
            AppAlert.Action(
                title: "Exit club",
                style: .destructive
            ) { dismiss in
                dismiss()
            }

            AppAlert.Action(
                title: "Cancel",
                style: .primary
            ) { dismiss in
                dismiss()
            }
        }
    ) )
   
}

#Preview("Title Only") {
    ZStack{
        Color.white.ignoresSafeArea()
    }
    .appAlert(isPresented: .constant(true), alert: .init(
        config: .init(
            title: "Network error"
        ),
        actions: {
            AppAlert.Action(
                title: "OK",
                style: .primary
            ) { dismiss in
                dismiss()
            }
        }
    ) )
   
}
