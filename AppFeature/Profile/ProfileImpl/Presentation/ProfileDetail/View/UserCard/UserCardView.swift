//
//  UserCardView.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 04.02.26.
//

import SwiftUI
import AppUIKit

struct UserCardView: View {
    
    let model: UserCardModel
    let onTap: (() -> Void)
    
    init(
        model: UserCardModel,
        onTap: @escaping () -> Void
    ) {
        self.model = model
        self.onTap = onTap
    }
    
    var body: some View {
        userCardView
            .modifier(
                PressTapButtonModifier {
                    onTap()
                }
            )
    }
    
    @ViewBuilder
    private var userCardView: some View {
        if let type = model.backgroundCover {
            CardBackgroundView(cardType: .club) {
                userInfoView
                    .padding(.horizontal)
                    .padding(.top)
            }
            .backgroundType(type)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.Palette.grayTeritary, lineWidth: 0.5)
            )
        } else {
            VStack {
                userInfoView
                    .padding(.horizontal)
                    .padding(.top)
            }
            .background(Color.Palette.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.Palette.grayTeritary, lineWidth: 0.5)
            )
        }
    }
    
    private var userInfoView: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 16) {
                userImage
                VStack(alignment: .leading, spacing: 12) {
                    nameAndSpecialtyView
                    communityBadgeView
                }
            }
            additionalInfoView
            emailView
        }
    }
    
    @ViewBuilder
    private var userImage: some View {
        let url = model.imageUrl
        CachedAsyncImage(url: url) { image in
            image
                .resizable()
        } placeholder: {
            Image(uiImage: UIImage.Icons.user)
        }
        .frame(width: 88, height: 88)
        .background(Color.Palette.grayQuaternary)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.Palette.blackHigh, lineWidth: 0.5)
        )
    }
    
    private var nameAndSpecialtyView: some View {
        VStack(alignment: .leading) {
            Text(model.nameSurname)
                .font(Font.Typography.HeadingXl.bold)
                .foregroundStyle(model.backgroundCover?.foregroundColor ?? Color.Palette.blackHigh)
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
            Text(model.speciality)
                .font(Font.Typography.TextMd.medium)
                .foregroundStyle(model.backgroundCover?.foregroundColor ?? Color.Palette.blackHigh)
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
        }
    }
    
    private var communityBadgeView: some View {
        Text(model.community)
            .font(Font.Typography.TextMd.bold)
            .foregroundStyle(Color.Palette.blackHigh)
            .padding(.vertical, 6)
            .padding(.horizontal, 16)
            .background(model.backgroundCover.isNil ? Color.Palette.primary : Color.Palette.whiteMedium)
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(Color.Palette.grayTeritary, lineWidth: 0.5)
            )
    }
    
    private var additionalInfoView: some View {
        HStack {
            additionalInfoItems(title: "course", subTitle: model.course)
            Spacer()
            additionalInfoItems(title: "degree", subTitle: model.degree)
            Spacer()
            additionalInfoItems(title: "entry", subTitle: model.entryYear)
        }
    }
    
    private func additionalInfoItems(
        title: String,
        subTitle: String
    ) -> some View {
        VStack {
            Text(title)
                .font(Font.Typography.TextSm.regular)
                .foregroundStyle(model.backgroundCover?.foregroundColor ?? Color.Palette.blackHigh)
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
                
            Text(subTitle)
                .font(Font.Typography.TextMd.medium)
                .foregroundStyle(model.backgroundCover?.foregroundColor ?? Color.Palette.blackHigh)
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
        }
    }
    
    private var emailView: some View {
        VStack(spacing: 16) {
            Divider()
                .background(model.backgroundCover?.foregroundColor ?? Color.Palette.blackHigh)
            
            HStack {
                Image(uiImage: UIImage.Icons.email)
                    .renderingMode(.template)
                    .foregroundStyle(model.backgroundCover?.foregroundColor ?? Color.Palette.blackHigh)
                Text(model.email)
                    .tint(model.backgroundCover?.foregroundColor ?? Color.Palette.blackHigh)
                    .foregroundStyle(model.backgroundCover?.foregroundColor ?? Color.Palette.blackHigh)
                    .font(Font.Typography.TextSm.regular)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .multilineTextAlignment(.leading)
            }
            .padding(.horizontal)
        }
        .padding(.bottom)
        .background(model.backgroundCover?.bgColor)
        .padding(.horizontal, -16)
    }
}

#Preview {
    ScrollView {
        VStack {
            UserCardView(
                model: UserCardModel.mock[1],
                onTap: {
                    
                }
            )
            .padding()
        }
    }
}
