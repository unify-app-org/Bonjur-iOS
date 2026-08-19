//
//  HangoutsCardView.swift
//  AppUIKit
//
//  Created by Huseyn Hasanov on 16.01.26.
//

import SwiftUI
import AppFoundation
import AppUIKit

struct HangoutsCardView: View {
    private let model: Model
    private let onButtonTap: (() -> Void)
    private let onTap: (() -> Void)
    
    init(
        model: Model,
        onButtonTap: @escaping (() -> Void),
        onTap: @escaping (() -> Void)
    ) {
        self.model = model
        self.onButtonTap = onButtonTap
        self.onTap = onTap
    }
    
    var body: some View {
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
                onTap()
            }
        )
    }
    
    @ViewBuilder
    private var topView: some View {
        let isPrivate = model.accessType == .private
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                dateBadge
                Text(isPrivate ? "Private".localized : "Public".localized)
                    .font(Font.Typography.TextSm.medium)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .foregroundStyle(isPrivate ? Color.Palette.blackHigh : Color.Palette.whiteHigh)
                    .background(isPrivate ? Color.Palette.white : Color.Palette.blackHigh)
                    .clipShape(Capsule())
                    .overlay(
                        Capsule()
                            .stroke(Color.Palette.blackHigh, lineWidth: 0.5)
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
                            .stroke(Color.Palette.blackHigh, lineWidth: 0.5)
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
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(Color.Palette.blackHigh)
            }
            metaRow
        }
    }

    @ViewBuilder
    private var dateBadge: some View {
        if let day = model.dateDay, let month = model.dateMonth {
            VStack(spacing: 0) {
                Text(month)
                    .font(Font.Typography.CaptionMd.medium)
                    .foregroundStyle(Color.Palette.destructiveRed)
                Text(day)
                    .font(Font.Typography.HeadingXl.bold)
                    .foregroundStyle(Color.Palette.blackHigh)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(Color.Palette.grayQuaternary)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }

    @ViewBuilder
    private var metaRow: some View {
        if model.time != nil || model.location != nil {
            HStack(spacing: 12) {
                if let time = model.time {
                    HStack(spacing: 5) {
                        Image(systemName: "clock")
                            .font(.system(size: 11, weight: .semibold))
                        Text(time)
                            .font(Font.Typography.TextSm.medium)
                    }
                }
                if let location = model.location {
                    HStack(spacing: 5) {
                        Image(systemName: "mappin.and.ellipse")
                            .font(.system(size: 11, weight: .semibold))
                        Text(location)
                            .font(Font.Typography.TextSm.medium)
                            .lineLimit(1)
                    }
                }
                Spacer()
            }
            .foregroundStyle(Color.Palette.graySecondary)
        }
    }
    
    private var bottomView: some View {
        VStack(alignment: .leading, spacing: 12) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(Array(model.tags.enumerated()), id: \.offset) { _, item in
                        Text("#\(item.title.lowercased())")
                            .lineLimit(1)
                            .font(Font.Typography.TextSm.regular)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.Palette.grayQuaternary)
                            .clipShape(Capsule())
                    }
                }
            }
            
            actionView
        }
    }

    @ViewBuilder
    private var actionView: some View {
        switch model.requestType {
        case .joined:
            statusLabel(
                icon: "checkmark",
                text: "hangouts_going".localized,
                foreground: Color.Palette.green900,
                background: Color.Palette.greenLight,
                border: Color.Palette.secondary
            )
        case .pending:
            statusLabel(
                icon: "clock",
                text: "Request sent",
                foreground: Color.Palette.graySecondary,
                background: Color.Palette.grayQuaternary,
                border: Color.Palette.grayTeritary
            )
        case .none, .rejected:
            AppButton(
                title: model.buttonTitle,
                model: .init(
                    contentSize: .fill,
                    size: .small
                )
            ) {
                onButtonTap()
            }
        }
    }

    private func statusLabel(
        icon: String,
        text: String,
        foreground: Color,
        background: Color,
        border: Color
    ) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 12, weight: .bold))
            Text(text)
                .font(Font.Typography.TextMd.medium)
        }
        .foregroundStyle(foreground)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(background)
        .clipShape(Capsule())
        .overlay(
            Capsule()
                .stroke(border, lineWidth: 1)
        )
    }
}

#Preview {
    ScrollView {
        VStack {
            HangoutsCardView(
                model: .previewMock[0],
                onButtonTap: {
                    
                }, onTap: {
                    
                }
            )
            .padding()
        }
    }
}
