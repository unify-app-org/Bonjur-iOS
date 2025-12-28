//
//  SearchView.swift
//  AppUIKit
//
//  Created by Huseyn Hasanov on 28.12.25.
//

import SwiftUI

public struct SearchView: View {
    
    var text: Binding<String>
    @FocusState private var isFocused: Bool
    
    public init(text: Binding<String>) {
        self.text = text
    }
    
    public var body: some View {
        HStack {
            Image(uiImage: UIImage.Icons.search)
                .resizable()
                .frame(width: 24, height: 24)

            TextField("Search", text: text)
                .focused($isFocused)
        }
        .padding(.horizontal)
        .padding(.vertical, 14)
        .background(Color.Palette.grayQuaternary)
        .clipShape(Capsule())
        .overlay(
            Capsule()
                .stroke(
                    Color.Palette.blackHigh,
                    lineWidth: isFocused ? 0.5 : 0.1
                )
        )
        .animation(.easeInOut(duration: 0.25), value: isFocused)
    }
    
}

#Preview {
    SearchView(text: .constant(""))
}
