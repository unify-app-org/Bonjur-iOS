//
//  AppTextField.swift
//  AppUIKit
//
//  Created by Huseyn Hasanov on 06.01.26.
//

import SwiftUI

public struct AppTextField: View {
    @FocusState private var isFocused: Bool
    
    let text: Binding<String>
    let placeHolder: String
    let axis: Axis
    let model: Model
    
    public init(
        text: Binding<String>,
        placeHolder: String,
        axis: Axis = .horizontal,
        model: Model = .init()
    ) {
        self.text = text
        self.placeHolder = placeHolder
        self.axis = axis
        self.model = model
    }
    
    public var body: some View {
        VStack(spacing: 12) {
            if let title = model.title {
                Text(title)
                    .font(Font.Typography.HeadingMd.medium)
                    .frame(
                        maxWidth: .infinity,
                        alignment: .leading
                    )
            }
            fieldBuilder
                .keyboardType(model.keyboardType)
                .focused($isFocused)
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
                .clipShape(Capsule())
                .overlay(
                    Capsule().stroke(
                        Color.Palette.graySecondary,
                        lineWidth: isFocused ? 1 : 0.5
                    )
                )
                .animation(
                    .easeIn(duration: 0.25),
                    value: isFocused
                )
        }
    }
    
    @ViewBuilder
    private var fieldBuilder: some View {
        switch model.type {
        case .normal:
            TextField(
                placeHolder,
                text: text,
                axis: axis
            )
        case .secure:
            SecureField(
                placeHolder,
                text: text
            )
        }
    }
}

#Preview {
    AppTextField(
        text: .constant(""),
        placeHolder: "Hello, World!",
        axis: .vertical,
        model: .init(title: "Email")
    )
    .padding()
}
