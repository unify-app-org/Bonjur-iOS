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
            .background(
                AppAlertPresentationBridge(
                    isPresented: $isPresented,
                    alert: alert
                )
                .frame(width: 0, height: 0)
            )
            .onDisappear {
                Task { @MainActor in
                    AppAlertPresenter.dismiss()
                }
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
    
    func appErrorAlert(
        alert: Binding<AppAlert.Config?>,
        buttonTitle: String = "Got it"
    ) -> some View {
        modifier(
            AppAlertModifier(
                isPresented: Binding(
                    get: { alert.wrappedValue != nil },
                    set: { if !$0 { alert.wrappedValue = nil } }
                ),
                alert: .init(
                    config: .init(
                        title: alert.wrappedValue?.title ?? "",
                        subtitle: alert.wrappedValue?.subtitle
                    ),
                    actions: [
                        .init(title: buttonTitle, style: .primary)
                    ]
                )
            )
        )
    }
}


#Preview("Primary + Secondary") {
    ZStack{
       
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
            )

            AppAlert.Action(
                title: "Join",
                style: .primary
            )
        }
    ) )
   
}

#Preview("Destructive + Primary") {
    ZStack{
        
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
            )

            AppAlert.Action(
                title: "Cancel",
                style: .primary
            )
        }
    ) )
   
}

#Preview("Error Alert") {
    ZStack{
       
    }
    .appErrorAlert(alert: .constant(.init(title: "Error", subtitle: "Something went wrong. Please try again.")))
   
   
}
