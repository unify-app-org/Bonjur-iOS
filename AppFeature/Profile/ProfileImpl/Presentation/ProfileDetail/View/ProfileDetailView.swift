//
//  ProfileDetailView.swift
//  ProfileImpl
//
//  Created by Huseyn Hasanov on 04.02.26.
//

import SwiftUI
import AppFoundation
import AppUIKit
import Clubs
import Events
import Hangouts

struct ProfileDetailView: View {
    @ObservedObject var store: StoreOf<ProfileDetailFeature>
    
    @State private var isSegmentSticky = false
    @State private var navBarHeight: CGFloat = 0
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
        GeometryReader { proxy in
            ZStack(alignment: .top) {
                mainScrollView(proxy)
                navigationOverlay(safeAreaTop: proxy.safeAreaInsets.top)
            }
            .ignoresSafeArea(edges: .top)
            .enableSwipeBack()
        }
        .animation(.easeInOut, value: store.state.selectedSegment)
        .onAppear {
            store.send(.fetchData)
        }
        .toolbar(.hidden)
    }
    
    // MARK: - Main Components
    
    private func mainScrollView(_ proxy: GeometryProxy) -> some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 26) {
                Color.clear
                    .frame(height: navBarHeight)
                userCardView
                userInfoView
                segmentView
                tabView
            }
            .padding(.horizontal)
        }
        .coordinateSpace(name: "scroll")
    }
    
    private func navigationOverlay(safeAreaTop: CGFloat) -> some View {
        VStack(spacing: 0) {
            customNavigationBar(safeAreaTop: safeAreaTop)
                .background(Color.white)
            
            if isSegmentSticky {
                segmentViewSticky
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.2), value: isSegmentSticky)
    }
    
    // MARK: - Navigation Bar
    
    private func customNavigationBar(safeAreaTop: CGFloat) -> some View {
        HStack {
            Text("Profile")
                .font(Font.Typography.TitleL.extraBold)
                .foregroundStyle(Color.Palette.black)
            
            Spacer()
            
            Button {
                
            } label: {
                Image(uiImage: UIImage.Icons.settings01)
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, safeAreaTop)
        .padding(.bottom, 8)
        .onGeometryChange(for: CGFloat.self) { $0.size.height } action: { newValue in
            navBarHeight = newValue - 16
        }
    }
    
    // MARK: - User Card
    
    @ViewBuilder
    private var userCardView: some View {
        if let data = store.state.uiModel?.userCardModel {
            UserCardView(model: data) {
                store.send(.userCardTapped)
            }
        }
    }
    
    // MARK: - User Info
    
    private var userInfoView: some View {
        AppInfoContainer(alignment: .leading, spacing: 16) {
            HStack {
                Text("About")
                    .font(Font.Typography.HeadingMd.medium)
                    .foregroundStyle(Color.Palette.black)
                
                Spacer()
                
                Button {
                    
                } label: {
                    Image(uiImage: UIImage.Icons.penLine)
                }
            }
            Text(store.state.uiModel?.about ?? "No information")
                .font(Font.Typography.BodyTextSm.regular)
                .foregroundStyle(Color.Palette.blackHigh)
            if store.state.uiModel?.tags.isEmpty == false {
                chipsView(data: store.state.uiModel?.tags ?? [])
            }
            VStack(spacing: 21) {
                userInfoCell(image: UIImage.Icons.genderIcon, title: "Gender", subtitle: store.state.uiModel?.gender ?? "-")
                userInfoCell(image: UIImage.Icons.cakeBirthday, title: "Birthday", subtitle: store.state.uiModel?.birthday ?? "-")
                userInfoCell(image: UIImage.Icons.globe01, title: "Languages", subtitle: store.state.uiModel?.languages?.joined(separator: ", ") ?? "-")
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
                    isSegmentSticky = minY <= navBarHeight
                }
            }
    }
    
    @ViewBuilder
    private var segmentViewSticky: some View {
        segmentPicker
            .padding(.horizontal, 16)
            .padding(.bottom, 8)
            .background(
                Color.white
                    .shadow(
                        color: Color.black.opacity(0.1),
                        radius: 4,
                        x: 0,
                        y: 2
                    )
            )
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
        let clubs = store.state.uiModel?.clubs ?? []
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
                    }
                }
            }
        }
        .padding(.bottom, 60)
    }
    
    @ViewBuilder
    private var eventsTab: some View {
        let events = store.state.uiModel?.events ?? []
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
                        }
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
        let hangouts = store.state.uiModel?.hangouts ?? []
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
