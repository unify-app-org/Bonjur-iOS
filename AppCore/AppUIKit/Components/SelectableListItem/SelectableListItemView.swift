//
//  SelectableListItemView.swift
//  AppCore
//
//  Created by Huseyn Hasanov on 26.12.25.
//

import SwiftUI

public struct SelectableListItemView: View {
    
    private let model: Model
    
    public init(model: Model) {
        self.model = model
    }
    
    public var body: some View {
        HStack {
            Text(model.title)
                .font(Font.Typography.BodyTextMd.medium)
                .foregroundStyle(Color.Palette.blackHigh)
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
            
            if model.style == .multySelect {
                Image(uiImage: model.selected  ? UIImage.Icons.selectedCheckBox : UIImage.Icons.notSelectedCheckBox)
            }
            
        }
        .padding(.horizontal, 25)
        .padding(.vertical, 16)
        .background(model.backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: .infinity))
        .overlay(
            RoundedRectangle(cornerRadius: .infinity)
                .strokeBorder(
                    model.borderColor,
                    lineWidth: model.borderWidth
                )
        )
        .contentShape(Rectangle())
    }
}
