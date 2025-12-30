//
//  CategorieChipsView.swift
//  AppFoundation
//
//  Created by Huseyn Hasanov on 30.12.25.e
//

import SwiftUI

public struct CategorieChipsView: View {
    private let model: Model
    
    public init(model: Model) {
        self.model = model
    }
    
    public var body: some View {
        Text(model.title)
            .foregroundStyle(Color.Palette.blackHigh)
            .padding(.horizontal, 24)
            .padding(.vertical, 10)
            .background(model.backgroundColor)
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(
                        model.borderColor,
                        lineWidth: 0.5
                    )
            )
            .fixedSize()
    }
}
