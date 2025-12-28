//
//  TextView.swift
//  AppCore
//
//  Created by Huseyn Hasanov on 28.12.25.
//


import SwiftUI

public struct TextView: View {
    
    var text: Binding<String>
    var characterLimit: Int = 500
    @State private var isFocused: Bool = false
    
    public init(text: Binding<String>, characterLimit: Int = 500) {
        self.text = text
        self.characterLimit = characterLimit
    }
    
    public var body: some View {
        VStack(alignment: .trailing, spacing: 8) {
            VStack {
                TextViewWrapper(
                    text: text,
                    isFocused: $isFocused,
                    characterLimit: characterLimit,
                    placeholder: "Write something"
                )
                .frame(minHeight: 40)
                
                Text("\(text.wrappedValue.count) / \(characterLimit)")
                    .font(.caption)
                    .foregroundColor(text.wrappedValue.count >= characterLimit ? .red : .secondary)
                    .padding(.trailing, 8)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding()
            .background(Color.Palette.grayQuaternary)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        Color.Palette.blackHigh,
                        lineWidth: isFocused ? 0.5 : 0.1
                    )
            )
            .animation(.easeInOut(duration: 0.25), value: isFocused)
        }
    }
}

#Preview {
    TextView(text: .constant(""), characterLimit: 10)
        .padding()
        .frame(height: 370)
}
