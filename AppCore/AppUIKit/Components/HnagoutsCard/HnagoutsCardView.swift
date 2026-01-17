//
//  HangoutsCardView.swift
//  AppUIKit
//
//  Created by Huseyn Hasanov on 16.01.26.
//

import SwiftUI

public struct HangoutsCardView: View {
    private let model: Model
    private let onButtonTap: ((AppUIEntities.AccessType, AppUIEntities.RequestType) -> Void)
    private let onTap: ((Model) -> Void)
    
    public init(
        model: Model,
        onButtonTap: @escaping ((AppUIEntities.AccessType, AppUIEntities.RequestType) -> Void),
        onTap: @escaping ((Model) -> Void)
    ) {
        self.model = model
        self.onButtonTap = onButtonTap
        self.onTap = onTap
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            topView
            bottomView
        }
        .padding()
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(
                    Color.Palette.grayTeritary
                )
        )
        .modifier(
            PressTapButtonModifier{
                onTap(model)
            }
        )
    }
    
    @ViewBuilder
    private var topView: some View {
        let isPrivate = model.accessType == .private
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Text(isPrivate ? "Private" : "Public")
                    .font(Font.Typography.TextSm.medium)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .foregroundStyle(isPrivate ? Color.Palette.blackHigh : Color.Palette.whiteHigh)
                    .background(isPrivate ? Color.Palette.white : Color.Palette.blackHigh)
                    .clipShape(Capsule())
                    .overlay(
                        Capsule()
                            .stroke(Color.Palette.blackHigh, lineWidth: 1)
                    )
                
                Text(model.memberCountText)
                    .font(Font.Typography.TextSm.medium)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .foregroundStyle(Color.Palette.blackHigh)
                    .background(Color.Palette.white)
                    .clipShape(Capsule())
                    .overlay(
                        Capsule()
                            .stroke(Color.Palette.blackHigh, lineWidth: 1)
                    )
            }
            
            VStack(spacing: 4) {
                Text(model.name)
                    .foregroundStyle(Color.Palette.blackHigh)
                    .font(Font.Typography.HeadingXl.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                Text(model.description)
                    .font(Font.Typography.TextL.regular)
                    .lineLimit(2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(Color.Palette.blackHigh)
            }
        }
    }
    
    private var bottomView: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                ForEach(model.tags, id: \.uuid) { item in
                    Text("#\(item.title.lowercased())")
                        .lineLimit(1)
                        .font(Font.Typography.TextSm.regular)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.Palette.grayQuaternary)
                        .clipShape(Capsule())
                }
            }
            
            if model.requestType != .joined {
                AppButton(
                    title: model.buttonTitle,
                    model: .init(
                        contentSize: .fill,
                        size: .small
                    )
                ) {
                    onButtonTap(model.accessType, model.requestType)
                }
                .disabled(model.requestType == .pending)
            }
        }
    }
}

#Preview {
    ScrollView {
        VStack {
            HangoutsCardView(
                model: HangoutsCardView.Model.mock[0],
                onButtonTap: { accessType, requestType in
                    
                }, onTap: { item in
                    
                }
            )
            .padding()
        }
    }
}
