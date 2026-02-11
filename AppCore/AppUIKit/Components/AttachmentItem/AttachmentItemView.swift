//
//  AttachmentItemView.swift
//  AppFoundation
//
//  Created by Huseyn Hasanov on 01.02.26.
//

import SwiftUI

public struct AttachmentItemView: View {
    
    private let model: Model
    
    public init(model: Model) {
        self.model = model
    }
    
    public var body: some View {
        HStack {
            Image(uiImage: model.image)
            VStack(alignment: .leading, spacing: 8) {
                Text(model.name)
                    .font(Font.Typography.BodyTextSm.medium)
                    .foregroundStyle(Color.Palette.blackHigh)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(model.size)
                    .font(Font.Typography.TextMd.regular)
                    .foregroundStyle(Color.Palette.blackMedium)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            if model.canEdit {
                Button {
                    
                } label: {
                    Image(uiImage: UIImage.Icons.trash)
                }
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.Palette.grayTeritary, lineWidth: 0.5)
        )
        .shadow(
            color: Color.Palette.grayTeritary.opacity(0.18),
            radius: 4,
            x: 0,
            y: 6
        )
        .padding(.horizontal, 4)
    }
}

#Preview {
    ScrollView {
        VStack {
            AttachmentItemView(
                model: .previewMock.first!
            )
        }
    }
}
