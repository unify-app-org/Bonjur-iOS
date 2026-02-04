//
//  UserCardView.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 04.02.26.
//

import SwiftUI
import AppUIKit

struct UserCardView: View {
    
    init() {
        AppFonts()
    }
    
    var body: some View {
        userCardView
            .modifier(
                PressTapButtonModifier {
                    
                }
            )
    }
    
    @ViewBuilder
    private var userCardView: some View {
        if true {
            CardBackgroundView(cardType: .club) {
                userInfoView
                    .padding(.horizontal)
                    .padding(.top)
            }
            .backgroundType(.primary)
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
        let url = URL(string: "https://via.placeholder.com/150")
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
            Text("Nihad Askerli")
                .font(Font.Typography.HeadingXl.bold)
                .foregroundStyle(Color.Palette.black)
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
            Text("Computer engineering")
                .font(Font.Typography.TextMd.medium)
                .foregroundStyle(Color.Palette.black)
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
        }
    }
    
    private var communityBadgeView: some View {
        Text("UFAZ")
            .font(Font.Typography.TextMd.bold)
            .foregroundStyle(Color.Palette.black)
            .padding(.vertical, 6)
            .padding(.horizontal, 16)
            .background(Color.Palette.primary)
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(Color.Palette.grayTeritary, lineWidth: 0.5)
            )
    }
    
    private var additionalInfoView: some View {
        HStack {
            additionalInfoItems(title: "course", subTitle: "2nd year")
            Spacer()
            additionalInfoItems(title: "degree", subTitle: "Master")
            Spacer()
            additionalInfoItems(title: "entry", subTitle: "2025")
        }
    }
    
    private func additionalInfoItems(
        title: String,
        subTitle: String
    ) -> some View {
        VStack {
            Text(title)
                .font(Font.Typography.TextSm.regular)
                .foregroundStyle(Color.Palette.blackMedium)
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
                
            Text(subTitle)
                .font(Font.Typography.TextMd.medium)
                .foregroundStyle(Color.Palette.black)
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
        }
    }
    
    private var emailView: some View {
        VStack(spacing: 16) {
            Divider()
            
            HStack {
                Image(uiImage: UIImage.Icons.email)
                Text("nihad@gmail.com")
                    .tint(Color.Palette.black)
                    .font(Font.Typography.TextSm.regular)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .multilineTextAlignment(.leading)
            }
            .padding(.horizontal)
        }
        .padding(.bottom)
        .background(Color.Palette.primary)
        .padding(.horizontal, -16)
    }
}

#Preview {
    ScrollView {
        VStack {
            UserCardView()
                .padding()
        }
    }
}
