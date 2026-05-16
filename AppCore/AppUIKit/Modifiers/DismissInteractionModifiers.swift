//
//  DismissInteractionModifiers.swift
//  AppUIKit
//
//  Created by Huseyn Hasanov on 11.05.26.
//

import SwiftUI
import UIKit

public extension View {
    func dismissKeyboardOnTap() -> some View {
        modifier(DismissKeyboardOnTapModifier())
    }
    
    func dismissDatePickerOnTap(isPresented: Binding<Bool>) -> some View {
        modifier(DismissDatePickerOnTapModifier(isPresented: isPresented))
    }
}

private struct DismissKeyboardOnTapModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(KeyboardDismissTapInstaller())
    }
}

private struct KeyboardDismissTapInstaller: UIViewRepresentable {
    func makeUIView(context: Context) -> KeyboardDismissTapView {
        KeyboardDismissTapView()
    }

    func updateUIView(_ uiView: KeyboardDismissTapView, context: Context) {}
}

private final class KeyboardDismissTapView: UIView, UIGestureRecognizerDelegate {
    private weak var installedWindow: UIWindow?
    private var tapGesture: UITapGestureRecognizer?

    override func didMoveToWindow() {
        super.didMoveToWindow()
        installTapGestureIfNeeded()
    }

    deinit {
        removeTapGesture()
    }

    private func installTapGestureIfNeeded() {
        guard installedWindow !== window else { return }
        removeTapGesture()

        guard let window else { return }

        let gesture = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard)
        )
        gesture.cancelsTouchesInView = false
        gesture.delegate = self

        window.addGestureRecognizer(gesture)
        installedWindow = window
        tapGesture = gesture
    }

    private func removeTapGesture() {
        if let tapGesture {
            installedWindow?.removeGestureRecognizer(tapGesture)
        }
        tapGesture = nil
        installedWindow = nil
    }

    @objc private func dismissKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }

    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldReceive touch: UITouch
    ) -> Bool {
        !touch.isInsideTextInput
    }
}

private extension UITouch {
    var isInsideTextInput: Bool {
        var currentView = view

        while let view = currentView {
            if view is UITextField || view is UITextView || view is UISearchBar {
                return true
            }
            currentView = view.superview
        }

        return false
    }
}

private struct DismissDatePickerOnTapModifier: ViewModifier {
    @Binding var isPresented: Bool
    
    func body(content: Content) -> some View {
        content
            .background {
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        dismissDatePicker()
                    }
            }
    }
    
    private func dismissDatePicker() {
        guard isPresented else { return }
        withAnimation {
            isPresented = false
        }
    }
}
