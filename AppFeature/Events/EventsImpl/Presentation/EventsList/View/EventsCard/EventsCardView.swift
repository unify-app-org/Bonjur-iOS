//
//  EventsCardView.swift
//  AppUIKit
//
//  Created by Huseyn Hasanov on 16.01.26.
//

import SwiftUI
import AppFoundation
import AppUIKit

struct EventsCardView: View {
    private let model: Model
    private let onButtonTap: (() -> Void)
    private let onTap: (() -> Void)
    private let onClubTap: ((Int) -> Void)?
    private let showCover: Bool

    init(
        showCover: Bool = true,
        model: Model,
        onButtonTap: @escaping (() -> Void),
        onTap: @escaping (() -> Void),
        onClubTap: ((Int) -> Void)? = nil
    ) {
        self.showCover = showCover
        self.model = model
        self.onButtonTap = onButtonTap
        self.onTap = onTap
        self.onClubTap = onClubTap
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            topView
            bottomView
        }
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
    
    private var topView: some View {
        VStack(alignment: .leading, spacing: 12) {
            coverView
            VStack(alignment: .leading, spacing: 8) {
                Text(model.name)
                    .foregroundStyle(Color.Palette.blackHigh)
                    .font(Font.Typography.HeadingXl.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                hostClubChip
                metaRow
            }
            .padding(.horizontal)
        }
    }
    
    @ViewBuilder
    private var coverView: some View {
        if showCover {
            CardBackgroundView(cardType: .club) {
                ZStack {
                    let url = URL(string: model.coverimageURL ?? "")
                    CachedAsyncImage(url: url) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 103)
                            .clipped()
                    } placeholder: {
                        Color.clear
                    }
                    
                    VStack {
                        topChipsView
                            .padding()
                        Spacer()
                    }
                }
                .frame(height: 103)
            }
            .cornerRadius(.zero)
            .backgroundType(model.bgType)
            // Clamp the whole cover: CardBackgroundView's RoundedRectangle/GeometryReader
            // are greedy, so without this it fills the proposed height (e.g. the club-detail
            // pager page) and the 103pt content floats in a tall band.
            .frame(height: 103)
            .clipped()
        } else {
            topChipsView
                .padding(.horizontal)
                .padding(.top)
        }
    }
    
    private var dateBadge: some View {
        VStack(spacing: 0) {
            Text(model.dateMonth)
                .font(Font.Typography.CaptionMd.medium)
                .foregroundStyle(Color.Palette.destructiveRed)
            Text(model.dateDay)
                .font(Font.Typography.HeadingXl.bold)
                .foregroundStyle(Color.Palette.blackHigh)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Color.Palette.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.12), radius: 4, y: 2)
    }

    @ViewBuilder
    private var topChipsView: some View {
        let isPrivate = model.accessType == .private
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
            Spacer()
        }
    }
    
    private var ownerBadge: some View {
        HStack(spacing: 4) {
            Text("👑")
            Text("events_owner_role".localized)
                .font(Font.Typography.TextSm.medium)
        }
        .foregroundStyle(Color.Palette.whiteHigh)
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(Color.Palette.blackHigh)
        .clipShape(Capsule())
    }
    
    private var hostClubChip: some View {
        Button {
            onClubTap?(model.club.id)
        } label: {
            HStack(spacing: 6) {
                Image(systemName: "person.2.fill")
                    .font(.system(size: 10))
                Text(model.club.name)
                    .font(Font.Typography.TextSm.medium)
                    .lineLimit(1)
                if onClubTap != nil {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 9, weight: .bold))
                }
            }
            .foregroundStyle(Color.Palette.green900)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(Color.Palette.greenLight)
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(Color.Palette.secondary, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .disabled(onClubTap == nil)
    }

    private var metaRow: some View {
        HStack(spacing: 12) {
            HStack(spacing: 5) {
                Image(systemName: "clock")
                    .font(.system(size: 11, weight: .semibold))
                Text(model.time)
                    .font(Font.Typography.TextSm.medium)
            }
            HStack(spacing: 5) {
                Image(systemName: "mappin.and.ellipse")
                    .font(.system(size: 11, weight: .semibold))
                Text(model.location)
                    .font(Font.Typography.TextSm.medium)
                    .lineLimit(1)
            }
            Spacer()
        }
        .foregroundStyle(Color.Palette.graySecondary)
    }

    private var bottomView: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                ForEach(Array(model.tags.enumerated()), id: \.offset) { _, item in
                    Text("#\(item.title.lowercased())")
                        .font(Font.Typography.TextSm.regular)
                        .lineLimit(1)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.Palette.grayQuaternary)
                        .clipShape(Capsule())
                }
            }

            actionView
        }
        .padding(.horizontal)
        .padding(.bottom)
    }

    @ViewBuilder
    private var actionView: some View {
        switch model.requestType {
        case .joined:
            statusLabel(
                icon: "checkmark",
                text: "events_going".localized,
                foreground: Color.Palette.green900,
                background: Color.Palette.greenLight,
                border: Color.Palette.secondary
            )
        case .pending:
            statusLabel(
                icon: "clock",
                text: "events_join_request_sent".localized,
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
            EventsCardView(
                model: .previewMock[0],
                onButtonTap: {
                    
                },
                onTap: {
                    
                }
            )
            .padding()
        }
    }
}
