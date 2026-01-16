//
//  ClubCardView.swift
//  AppFoundation
//
//  Created by Huseyn Hasanov on 16.01.26.
//

import SwiftUI

public struct ClubCardView: View {
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
        CardBackgroundView(cardType: .club) {
            VStack(spacing: 27) {
                topLeftView
                bottomView
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
    
    private var topLeftView: some View {
        VStack(alignment: .leading) {
            logoImage
            Text(model.name)
                .font(Font.Typography.TitleMd.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
                .foregroundStyle(model.bgType.foregroundColor)
            Text(model.communityName)
                .font(Font.Typography.TextMd.regular)
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
                .foregroundStyle(model.bgType.foregroundColor)
        }
    }
    
    @ViewBuilder
    private var logoImage: some View {
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
            Text("\(model.memberCount) members")
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
                model: ClubCardView.Model.mock
            ) { item in
                
            }
            .padding()
        }
    }
}
