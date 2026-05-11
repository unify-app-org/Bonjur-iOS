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
            .background {
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        dismissKeyboard()
                    }
            }
    }
    
    private func dismissKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
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
