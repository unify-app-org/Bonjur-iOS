//
//  TextView.swift
//  AppCore
//
//  Created by Huseyn Hasanov on 28.12.25.
//


import SwiftUI
import AppLocalization

public struct TextView: View {
    
    private var text: Binding<String>
    private var characterLimit: Int = 500
    private let model: TextView.Model
    @State private var isFocused: Bool = false
    @Environment(\.isEnabled) private var isEnabled
    
    public init(
        text: Binding<String>,
        characterLimit: Int = 500,
        model: TextView.Model = .init()
    ) {
        self.text = text
        self.characterLimit = characterLimit
        self.model = model
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let title = model.title {
                Text(title)
                    .font(Font.Typography.HeadingMd.medium)
                    .frame(
                        maxWidth: .infinity,
                        alignment: .leading
                    )
            }
            VStack(alignment: .trailing, spacing: 8) {
                TextViewWrapper(
                    text: text,
                    isFocused: $isFocused,
                    characterLimit: characterLimit,
                    placeholder: "field_write_something".localized,
                    keyboardType: model.keyboardType
                )
                .frame(minHeight: 40)
                
                Text("\(text.wrappedValue.count) / \(characterLimit)")
                    .font(.caption)
                    .foregroundColor(text.wrappedValue.count >= characterLimit ? .red : .secondary)
                    .padding(.trailing, 8)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding()
            .background(Color.clear)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        Color.Palette.graySecondary,
                        lineWidth: isEnabled ? isFocused ? 1 : 0.5 : 0
                    )
            )
            .animation(.easeInOut(duration: 0.25), value: isFocused)
            .background(isEnabled ? Color.clear : Color.Palette.grayQuaternary)
        }
    }
}

#Preview {
    TextView(text: .constant(""), characterLimit: 10)
        .padding()
        .frame(height: 370)
}

public extension TextView {
    
    struct Model {
        let title: String?
        let keyboardType: UIKeyboardType
        
        public init(
            title: String? = nil,
            keyboardType: UIKeyboardType = .default
        ) {
            self.keyboardType = keyboardType
            self.title = title
        }
    }
}
