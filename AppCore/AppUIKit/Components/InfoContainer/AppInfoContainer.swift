//
//  AppInfoContainer.swift
//  AppCore
//
//  Created by Huseyn Hasanov on 31.01.26.
//

import SwiftUI

public struct AppInfoContainer<Content: View>: View {
    private let content: () -> Content
    private var spacing: CGFloat
    private var alignment: HorizontalAlignment

    public init(
        alignment: HorizontalAlignment = .leading,
        spacing: CGFloat = 16,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.spacing = spacing
        self.alignment = alignment
        self.content = content
    }

    public var body: some View {
        VStack(alignment: alignment, spacing: spacing) {
            content()
        }
        .padding()
        .background(Color.Palette.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.Palette.grayTeritary, lineWidth: 0.5)
        )
        .background(
            RoundedRectangle(cornerRadius: 16)
                .shadow(
                    color: Color.Palette.grayTeritary.opacity(0.18),
                    radius: 4,
                    x: 0,
                    y: 6
                )
        )
    }
}
