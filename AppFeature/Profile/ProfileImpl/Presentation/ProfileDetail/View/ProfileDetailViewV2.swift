//
//  ProfileDetailViewV2.swift
//  ProfileImpl
//
//  Created by Huseyn Hasanov on 04.02.26.

import SwiftUI
import AppFoundation
import AppUIKit
import Clubs
import Events
import Hangouts

struct ProfileDetailViewV2: View {
    @ObservedObject var store: StoreOf<ProfileDetailFeature>

    @State private var isSegmentSticky = false
    @State private var tabHeights: [ProfileDetailViewState.SegmentTypes: CGFloat] = [:]

    private let clubsModule: ClubsModule
    private let eventsModule: EventsModule
    private let hangoutsModule: HangoutsModule

    init(
        store: StoreOf<ProfileDetailFeature>,
        clubsModule: ClubsModule = resolve(),
        eventsModule: EventsModule = resolve(),
        hangoutsModule: HangoutsModule = resolve()
    ) {
        self.store = store
        self.clubsModule = clubsModule
        self.eventsModule = eventsModule
        self.hangoutsModule = hangoutsModule
    }

    var body: some View {
        mainScrollView
            .animation(.easeInOut, value: store.state.selectedSegment)
            .onAppear {
                store.send(.fetchData)
            }
            .navigationTitle(store.state.navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.visible)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    if !store.state.isOtherUser {
                        Button {
                            store.send(.settingsTapped)
                        } label: {
                            Image(uiImage: UIImage.Icons.settings01)
                                .renderingMode(.template)
                        }
                        .foregroundStyle(Color.Palette.black)
                    }
                }
            }
            .enableSwipeBack()
    }

    // MARK: - Main Components

    private var mainScrollView: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 22) {
                compactHeaderView
                aboutBoxView
                activitySummaryCard
            }
            .padding(.horizontal)
            .padding(.top, 8)
        }
        .coordinateSpace(name: "scroll")
    }

    // MARK: - Compact Header

    @ViewBuilder
    private var compactHeaderView: some View {
        if let card = store.state.uiModel?.userCardModel {
            VStack(spacing: 0) {
                CachedAsyncImage(url: card.imageUrl) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    Image(uiImage: UIImage.Icons.user)
                        .renderingMode(.template)
                        .foregroundStyle(Color.Palette.blackMedium)
                }
                .frame(width: 88, height: 88)
                .clipShape(Circle())
                .overlay(
                    Circle().stroke(
                        Color.Palette.grayTeritary.opacity(0.3),
                        lineWidth: 3
                    )
                )

                Text(card.nameSurname)
                    .font(Font.Typography.TitleMd.bold)
                    .foregroundStyle(Color.Palette.black)
                    .padding(.top, 14)

                Text(headerSubtitle(for: card))
                    .font(Font.Typography.BodyTextSm.bold)
                    .foregroundStyle(Color.Palette.blackMedium)
                    .multilineTextAlignment(.center)
                    .padding(.top, 3)

                cardChip
                    .padding(.top, 14)
            }
            .frame(maxWidth: .infinity)
        }
    }

    private func headerSubtitle(for card: UserCardModel) -> String {
        [card.speciality, card.community]
            .filter { !$0.isEmpty }
            .joined(separator: " · ")
    }

    private var cardChip: some View {
        Button {
            guard !store.state.isOtherUser else { return }
            store.send(.userCardTapped)
        } label: {
            HStack(spacing: 4) {
                Text("🪪  User Card ID")
                    .font(Font.Typography.TextMd.bold)
                Image(uiImage: UIImage.Icons.chevronRight)
                    .renderingMode(.original)
                    .resizable()
                    .frame(width: 16, height: 16)
            }
            .foregroundStyle(Color.Palette.green900)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Color.Palette.greenLight)
            .overlay(
                Capsule().stroke(Color.Palette.secondary, lineWidth: 1)
            )
            .clipShape(Capsule())
        }
    }

    // MARK: - About Box (inline edit pen)

    private var aboutBoxView: some View {
        AppInfoContainer(alignment: .leading, spacing: 16) {
            HStack {
                Text("About")
                    .font(Font.Typography.HeadingMd.medium)
                    .foregroundStyle(Color.Palette.black)

                Spacer()

                if !store.state.isOtherUser {
                    Button {
                        store.send(.editProfile)
                    } label: {
                        Image(uiImage: UIImage.Icons.penLine)
                            .padding(8)
                            .background(Color.Palette.grayQuaternary)
                            .clipShape(Circle())
                    }
                }
            }

            Text(store.state.uiModel?.about ?? "No information")
                .font(Font.Typography.BodyTextSm.regular)
                .foregroundStyle(Color.Palette.blackHigh)

            if store.state.uiModel?.tags.isEmpty == false {
                chipsView(data: store.state.uiModel?.tags ?? [])
            }

            VStack(spacing: 21) {
                userInfoCell(image: UIImage.Icons.genderIcon, title: "Gender", subtitle: store.state.uiModel?.gender?.title ?? "-")
                userInfoCell(image: UIImage.Icons.cakeBirthday, title: "Birthday", subtitle: store.state.uiModel?.birthday ?? "-")
                userInfoCell(
                    image: UIImage.Icons.globe01, title: "Languages",
                    subtitle: store.state.uiModel?.languages?
                        .map({ $0.title })
                        .joined(separator: ", ") ?? "-"
                )
            }
        }
    }

    @ViewBuilder
    private func chipsView(data: [AppUIEntities.Tags]) -> some View {
        FlowLayout(items: data) { item in
            Text("#\(item.title.lowercased())")
                .font(Font.Typography.TextSm.regular)
                .lineLimit(1)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.Palette.grayQuaternary)
                .clipShape(Capsule())
        }
    }

    private func userInfoCell(
        image: UIImage,
        title: String,
        subtitle: String
    ) -> some View {
        HStack(spacing: 16) {
            Image(uiImage: image)
                .padding(10)
                .background(Color.Palette.grayQuaternary)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            VStack(spacing: 9) {
                VStack(spacing: 4) {
                    Text(title)
                        .font(Font.Typography.TextMd.regular)
                        .foregroundStyle(Color.Palette.blackMedium)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .multilineTextAlignment(.leading)
                    Text(subtitle)
                        .font(Font.Typography.BodyTextSm.regular)
                        .foregroundStyle(Color.Palette.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .multilineTextAlignment(.leading)
                }
                Divider()
            }
        }
    }

    // MARK: - Activity Summary Card

    private var activitySummaryCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("Your activities")
                    .font(Font.Typography.HeadingMd.medium)
                    .foregroundStyle(Color.Palette.green900)
                Spacer()
            }

            Text("Clubs, events & hangouts you've joined or created")
                .font(Font.Typography.TextSm.regular)
                .foregroundStyle(Color.Palette.green900.opacity(0.8))

            HStack(spacing: 8) {
                countCell(value: store.state.clubs.count, label: "Clubs")
                countCell(value: store.state.events.count, label: "Events")
                countCell(value: store.state.hangouts.count, label: "Hangouts")
            }
        }
        .padding(16)
        .background(Color.Palette.greenLight)
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(Color.Palette.secondary, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }

    private func countCell(value: Int, label: String) -> some View {
        VStack(spacing: 2) {
            Text("\(value)")
                .font(Font.Typography.HeadingMd.medium)
                .foregroundStyle(Color.Palette.black)
            Text(label)
                .font(Font.Typography.TextSm.regular)
                .foregroundStyle(Color.Palette.blackMedium)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 11)
        .background(Color.Palette.white)
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}
