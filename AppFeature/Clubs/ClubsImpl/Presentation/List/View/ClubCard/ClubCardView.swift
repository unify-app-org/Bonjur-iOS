//
//  ClubCardView.swift
//  AppFoundation
//
//  Created by Huseyn Hasanov on 16.01.26.
//

import SwiftUI
import AppFoundation
import AppUIKit

struct ClubCardView: View {
    private let model: Model
    private let onTap: (() -> Void)
    
    private var statusChipTitle: String? {
        switch model.requestType {
        case .joined: return "✓ Joined"
        case .pending: return "⏳ Pending"
        case .rejected, .none: return nil
        }
    }

    private var joinedRole: AppUIEntities.UserActivityRole? {
        guard let role = model.role, role.isJoinedRole else { return nil }
        return role
    }

    private func roleBadgeText(
        _ role: AppUIEntities.UserActivityRole
    ) -> String {
        role == .president ? "👑 " + "Owner".localized : role.displayTitle.localized
    }
    
    init(
        model: Model,
        onTap: @escaping (() -> Void)
    ) {
        self.model = model
        self.onTap = onTap
    }
    
    var body: some View {
        CardBackgroundView(cardType: .club) {
            VStack(spacing: 8) {
                topLeftView
                bottomView
            }
            .padding()
        }
        .backgroundType(model.bgType)
        .modifier(
            PressTapButtonModifier {
                onTap()
            }
        )
    }
    
    private var topLeftView: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                logoImage
                Spacer()
                accessChip
            }
            HStack(spacing: 4) {
                Text(model.name)
                    .font(Font.Typography.TitleMd.bold)
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(model.bgType.foregroundColor)
                if model.isVerified {
                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(model.bgType.foregroundColor)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            upCommingEventsCountView
            categoriesRow
        }
    }

    private var categoriesRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 6) {
                ForEach(model.categories, id: \.self) { category in
                    Text(category)
                        .font(Font.Typography.TextSm.medium)
                        .lineLimit(1)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 3)
                        .foregroundStyle(Color.Palette.blackHigh)
                        .background(Color.Palette.whiteMedium)
                        .clipShape(Capsule())
                }
            }
        }
        .padding(.top, 2)
    }
    
    private var upCommingEventsCountView: some View {
        HStack(spacing: 4) {
            Text(model.communityName)
            Text("•")
            let text = model.upcomingEventsCount == 1
            ? "1 event"
            : "count_events".localized(with: model.upcomingEventsCount)
            Image(systemName: "calendar")
            Text(text)
            if let role = joinedRole {
                Text("•")
                Text(roleBadgeText(role))
            }
        }
        .foregroundStyle(model.bgType.foregroundColor)
        .font(Font.Typography.TextSm.medium)
    }
    
    private var accessChip: some View {
        Text(model.accessType == .private ? "Private".localized : "Public".localized)
            .font(Font.Typography.TextSm.medium)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .foregroundStyle(Color.Palette.blackHigh)
            .background(Color.Palette.whiteHigh)
            .clipShape(Capsule())
    }

    @ViewBuilder
    private var logoImage: some View {
        let url = URL(string: model.logoURL)
        CachedAsyncImage(url: url) { image in
            image
                .resizable()
                .clipShape(RoundedRectangle(cornerRadius: .infinity))
                .overlay(
                    Circle().stroke(
                        Color.Palette.whiteHigh,
                        lineWidth: 2
                    )
                )
                .frame(width: 40, height: 40)
        } placeholder: {
            Text("🤙")
                .frame(width: 40, height: 40)
                .foregroundStyle(Color.Palette.black)
                .background(Color.Palette.white)
                .clipShape(Circle())
        }
    }
    
    private var bottomView: some View {
        HStack(spacing: 20) {
            membersView
            Spacer()
            Image(uiImage: UIImage.Icons.arrowLeft01)
                .renderingMode(.template)
                .resizable()
                .rotationEffect(.degrees(135))
                .frame(width: 20, height: 20)
                .padding(10)
                .background(model.bgType.arrowBgColor)
                .foregroundStyle(model.bgType.arrowTint)
                .clipShape(Circle())
        }
    }
    
    @ViewBuilder
    private var membersView: some View {
        HStack(spacing: 8) {
            HStack(spacing: -10) {
                ForEach(Array(model.members.enumerated()), id: \.element.id) { index, member in
                    let url = URL(string: member.profileImage ?? "")
                    CachedAsyncImage(url: url) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Image(systemName: "person")
                            .resizable()
                            .padding(6)
                            .foregroundStyle(Color.Palette.black)
                    }
                    .frame(width: 24, height: 24)
                    .background(Color.Palette.grayQuaternary)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(
                                Color.Palette.white,
                                lineWidth: 1
                            )
                    )
                    .zIndex(Double(3 - index))
                }
            }
            Text(
                model.totalCapacity > 0
                ? "count_of_members".localized(with: model.memberCount, model.totalCapacity)
                : "count_members".localized(with: model.memberCount)
            )
            .font(Font.Typography.TextMd.regular)
            .foregroundColor(model.bgType.foregroundColor)
            .frame(maxWidth: .infinity, alignment: .leading)
            .multilineTextAlignment(.leading)
        }
    }
}

#Preview {
    ScrollView {
        VStack {
            ClubCardView(
                model: .previewData[0]
            ) {
                
            }
            .padding()
        }
    }
}
