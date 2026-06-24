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
        ZStack(alignment: .top) {
            mainScrollView
            
            if isSegmentSticky {
                segmentViewSticky
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
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
                segmentView
                tabView
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

                if !store.state.isOtherUser {
                    cardChip(for: card)
                        .padding(.top, 14)
                }
            }
            .frame(maxWidth: .infinity)
        }
    }

    private func headerSubtitle(for card: UserCardModel) -> String {
        [card.speciality, card.course, card.community]
            .filter { !$0.isEmpty && $0 != "-" }
            .joined(separator: " · ")
    }

    private func cardChip(for card: UserCardModel) -> some View {
        // Tint from the selected card cover; fall back to the original green.
        // `.primary` is a pale green that's unreadable as text, so it reuses the
        // dark green pair like the nil case.
        let chipForeground: Color
        let chipBackground: Color
        switch card.backgroundCover {
        case .primary, .none:
            chipForeground = Color.Palette.green900
            chipBackground = Color.Palette.greenLight
        case .some(let cover):
            chipForeground = cover.bgColor
            chipBackground = cover.bgColor.opacity(0.18)
        }
        return Button {
            guard !store.state.isOtherUser else { return }
            store.send(.userCardTapped)
        } label: {
            HStack(spacing: 4) {
                Text("🪪  User Card ID")
                    .font(Font.Typography.TextMd.bold)
                Image(uiImage: UIImage.Icons.chevronRight)
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 16, height: 16)
            }
            .foregroundStyle(chipForeground)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(chipBackground)
            .overlay(
                Capsule().stroke(chipForeground.opacity(0.5), lineWidth: 1)
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

    @ViewBuilder
    private var activitySummaryCard: some View {
        if store.state.isOtherUser {
            activitySummaryCardContent
        } else {
            Button {
                store.send(.activitiesTapped)
            } label: {
                activitySummaryCardContent
            }
            .buttonStyle(.plain)
        }
    }

    private var activitySummaryCardContent: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("Your activities")
                    .font(Font.Typography.HeadingMd.medium)
                    .foregroundStyle(Color.Palette.green900)
                Spacer()
                if !store.state.isOtherUser {
                    Image(uiImage: UIImage.Icons.chevronRight)
                        .renderingMode(.original)
                        .resizable()
                        .frame(width: 18, height: 18)
                }
            }

            Text("Clubs, events & hangouts you've joined or created")
                .font(Font.Typography.TextSm.regular)
                .foregroundStyle(Color.Palette.green900.opacity(0.8))
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)

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
    
    // MARK: - Segments
    
    @ViewBuilder
    private var segmentView: some View {
        segmentPicker
            .background(Color.white)
            .opacity(isSegmentSticky ? 0 : 1)
            .onGeometryChange(for: CGFloat.self) {
                $0.frame(in: .named("scroll")).minY
            } action: { minY in
                withAnimation(.easeInOut(duration: 0.2)) {
                    isSegmentSticky = minY <= 0
                }
            }
    }
    
    @ViewBuilder
    private var segmentViewSticky: some View {
        segmentPicker
            .padding(.horizontal, 16)
            .padding(.vertical, 4)
            .mask(
                Rectangle().padding(.bottom, -10)
            )
    }
    
    private var segmentPicker: some View {
        CapsuleSegmentedPicker(
            selection: Binding(
                get: { store.state.selectedSegment },
                set: { newValue in
                    withAnimation(.easeInOut) {
                        store.state.selectedSegment = newValue
                    }
                }
            )
        )
    }
    
    // MARK: - Tabs
    
    @ViewBuilder
    private var tabView: some View {
        TabView(
            selection: Binding(
                get: { store.state.selectedSegment },
                set: { newValue in
                    withAnimation(.easeInOut) {
                        store.state.selectedSegment = newValue
                    }
                }
            )
        ) {
            tabContent(for: .clubs, content: clubsTab)
            tabContent(for: .events, content: eventsTab)
            tabContent(for: .hangouts, content: hangoutsTab)
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(height: tabHeights[store.state.selectedSegment] ?? 300)
        .animation(.spring(response: 0.1, dampingFraction: 1), value: tabHeights[store.state.selectedSegment])
        .onPreferenceChange(TabHeightPreferenceKey.self) { heights in
            tabHeights.merge(heights) { _, new in new }
        }
    }
    
    private func tabContent<Content: View>(
        for segment: ProfileDetailViewState.SegmentTypes,
        content: Content
    ) -> some View {
        content
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .background(
                GeometryReader { geo in
                    Color.clear.preference(
                        key: TabHeightPreferenceKey.self,
                        value: [segment: geo.size.height]
                    )
                }
            )
            .tag(segment)
    }
    
    // MARK: - Tab Contents
    
    @ViewBuilder
    private var clubsTab: some View {
        let clubs = store.state.clubs
        VStack(spacing: 16) {
            if clubs.isEmpty {
                emptyStateView(message: "No clubs yet")
            } else {
                ForEach(Array(clubs.enumerated()), id: \.element.uuid) { index, item in
                    if let view = clubsModule.makeCardView(
                        inputData: item,
                        onTap: {
                            store.send(.clubsItemTapped(item.id))
                        }
                    ) as? AnyView {
                        view
                            .frame(height: 220)
                    }
                }
            }
        }
        .padding(.bottom, 60)
    }
    
    @ViewBuilder
    private var eventsTab: some View {
        let events = store.state.events
        VStack(spacing: 16) {
            if events.isEmpty {
                emptyStateView(message: "No events yet")
            } else {
                ForEach(Array(events.enumerated()), id: \.element.uuid) { index, item in
                    if let view = eventsModule.makeEventsCard(
                        model: item,
                        onTap: {
                            store.send(.eventsItemTapped(item.id))
                        },
                        onButtonTap: {
                            // Handle button tap
                        },
                        onClubTap: nil
                    ) as? AnyView {
                        view
                    }
                }
            }
        }
        .padding(.bottom, 60)
    }
    
    @ViewBuilder
    private var hangoutsTab: some View {
        let hangouts = store.state.hangouts
        VStack(spacing: 16) {
            if hangouts.isEmpty {
                emptyStateView(message: "No hangouts yet")
            } else {
                ForEach(Array(hangouts.enumerated()), id: \.element.uuid) { index, item in
                    if let view = hangoutsModule.makeHangoutsCard(
                        model: item,
                        onTap: {
                            store.send(.hangoutsItemTapped(item.id))
                        },
                        onButtonTap: {
                            // Handle button tap
                        }
                    ) as? AnyView {
                        view
                    }
                }
            }
        }
        .padding(.bottom, 60)
    }
    
    private func emptyStateView(message: String) -> some View {
        Text(message)
            .font(Font.Typography.BodyTextSm.regular)
            .foregroundStyle(Color.Palette.blackMedium)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 40)
    }
}
