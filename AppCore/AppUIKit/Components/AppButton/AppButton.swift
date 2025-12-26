//
//  AppButton.swift
//  AppFoundation
//
//  Created by Huseyn Hasanov on 23.12.25.
//

import SwiftUI

public struct AppButton: View {
    let title: String
    let action: (() -> Void)
    let model: Model
    @Environment(\.isEnabled) private var isEnabled

    public init(
        title: String,
        model: Model = .init(),
        action: @escaping (() -> Void)
    ) {
        self.action = action
        self.title = title
        self.model = model
    }
    
    public var body: some View {
        Button(action: action) {
            Text(title)
                .font(model.textFont)
                .padding(model.edges)
                .frame(
                    maxWidth: model.contentSize == .fill ? .infinity : nil
                )
                .background(isEnabled ? model.backgroundColor : Color.Palette.onBackground)
                .foregroundStyle(isEnabled ? model.foregroundColor : Color.Palette.blackDisabled)
                .clipShape(
                     RoundedRectangle(
                         cornerRadius: .infinity
                     )
                 )
                 .overlay(
                     RoundedRectangle(cornerRadius: .infinity)
                         .strokeBorder(
                             model.borderColor,
                             lineWidth: model.borderWidth
                         )
                 )
        }
    }
}
