//
//  ScaleOpacityButtonStyle.swift
//  AppCore
//
//  Created by Huseyn Hasanov on 16.01.26.
//

import SwiftUI

public struct ScaleOpacityButtonStyle: ButtonStyle {
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.975 : 1)
            .opacity(configuration.isPressed ? 0.75 : 1)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}

public struct PressTapButtonModifier: ViewModifier {
    let action: () -> Void

    @State private var isPressed = false

    public func body(content: Content) -> some View {
        content
            .scaleEffect(isPressed ? 0.975 : 1)
            .opacity(isPressed ? 0.8 : 1)
            .animation(.easeInOut(duration: 0.15), value: isPressed)
            .contentShape(Rectangle())
            ._onButtonGesture(pressing: { pressing in
                withAnimation(.easeInOut(duration: 0.15)) {
                    isPressed = pressing
                }
            }, perform: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isPressed = true
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isPressed = false
                    }
                }
                
                action()
            })
    }
}
