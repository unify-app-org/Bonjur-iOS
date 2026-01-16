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

    @GestureState private var isPressed = false
    @State private var isInside = true
    @State private var isTapped = false

    public func body(content: Content) -> some View {
        content
            .scaleEffect(isPressed ? 0.975 : (isTapped ? 1.03 : 1))
            .opacity(isPressed ? 0.75 : 1)
            .animation(.easeInOut(duration: 0.15), value: isPressed)
            .animation(.spring(response: 0.25, dampingFraction: 0.55), value: isTapped)
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .updating($isPressed) { value, state, _ in
                        state = true
                        isInside = true
                    }
                    .onChanged { value in
                        if abs(value.translation.width) > 20 ||
                           abs(value.translation.height) > 20 {
                            isInside = false
                        }
                    }
                    .onEnded { _ in
                        if isInside {
                            isTapped = true
                            action()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                isTapped = false
                            }
                        }
                        isInside = true
                    }
            )
    }
}


