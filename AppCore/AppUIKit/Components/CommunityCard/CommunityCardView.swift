//
//  CommunityCardView.swift
//  AppUIKit
//
//  Created by Huseyn Hasanov on 16.01.26.
//

import SwiftUI

public struct CommunityCardView: View {
    private let model: Model
    private let onTap: ((Model) -> Void)

    public init(
        model: Model,
        onTap: @escaping ((Model) -> Void)
    ) {
        self.model = model
        self.onTap = onTap
    }
    
    public var body: some View {
        CardBackgroundView(cardType: .community) {
            VStack(spacing: 48) {
                topView
                HStack {
                    Spacer()
                    membersView
                }
            }
            .padding()
        }
        .backgroundType(model.bgType)
        .modifier(
            PressTapButtonModifier {
                onTap(model)
            }
        )
    }
    
    @ViewBuilder
    private var topView: some View {
        HStack(spacing: 12) {
            logoView
            VStack {
                Text(model.name)
                    .font(Font.Typography.TitleMd.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .multilineTextAlignment(.leading)
                Text(model.subTitle)
                    .font(Font.Typography.TextMd.regular)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .multilineTextAlignment(.leading)
            }
            HStack(spacing: 4) {
                Text("view all")
                    .font(Font.Typography.TextMd.medium)
                Image(uiImage: UIImage.Icons.arrowLeft01)
                    .renderingMode(.template)
                    .resizable()
                    .rotationEffect(.degrees(135))
                    .frame(width: 20, height: 20)
            }
            .padding(10)
            .background(model.bgType.arrowBgColor)
            .foregroundStyle(model.bgType.arrowTint)
            .clipShape(RoundedRectangle(cornerRadius: .infinity))
        }
    }
    
    @ViewBuilder
    private var logoView: some View {
        let url = URL(string: model.logoURL)
        AsyncImage(url: url) { image in
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
            Text("⚽️")
                .frame(width: 40, height: 40)
                .foregroundStyle(Color.Palette.black)
                .background(Color.Palette.white)
                .clipShape(Circle())
        }
    }
    
    @ViewBuilder
    private var membersView: some View {
        HStack(spacing: 8) {
            Text("\(model.memberCount) members")
                .font(Font.Typography.TextMd.regular)
                .foregroundColor(model.bgType.foregroundColor)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .multilineTextAlignment(.leading)
            HStack(spacing: -10) {
                ForEach(Array(model.members.enumerated()), id: \.element.uuid) { index, member in
                    AsyncImage(url: URL(string: member.profileImage ?? "")) { image in
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
        }
    }
}

#Preview {
    ScrollView {
        VStack {
            CommunityCardView(
                model: CommunityCardView.Model.mock
            ) { item in
                
            }
            .padding()
        }
    }
}
