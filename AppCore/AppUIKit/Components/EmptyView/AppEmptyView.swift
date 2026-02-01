//
//  AppEmptyView.swift
//  AppUIKit
//
//  Created by Huseyn Hasanov on 20.01.26.
//

import SwiftUI

public struct AppEmptyView: View {
    private let model: Model
    private let completion: (() -> Void)
    
    public init(
        model: Model,
        completion: @escaping (() -> Void)
    ) {
        self.model = model
        self.completion = completion
    }
    
    public var body: some View {
        VStack(spacing: 12) {
            if let icon = model.icon {
                Image(uiImage: icon)
                    .padding(12)
                    .background(Color.Palette.grayQuaternary)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            Text(model.text)
                .font(Font.Typography.BodyTextSm.medium)
                .frame(maxWidth: .infinity, alignment: .center)
                .multilineTextAlignment(.center)
                .foregroundStyle(Color.Palette.blackMedium)
            AppButton(
                title: model.buttonTitle,
                model: .init(
                    contentSize: .fill,
                    size: .small
                )
            ) {
                completion()
            }
            .padding(.horizontal, 40)
        }
        .padding(16)
        .background(Color.Palette.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [5, 5]))
                .foregroundStyle(Color.Palette.grayTeritary.opacity(0.3))
        )
        .shadow(
            color: Color.Palette.grayQuaternary,
            radius: 10,
            x: 0,
            y: 6
        )
    }
}

#Preview {
    AppEmptyView(
        model: .init(
            icon: UIImage.Icons.twoUsers,
            text: "There are no clubs for this community yet. Be the pioneer and start the very first one now!",
            buttonTitle: "Create a club +"
        )
    ) {
        
    }
    .padding()
}
