//
//  CommunityDetailView.swift
//  CommunitiesImpl
//
//  Created by Huseyn Hasanov on 03.02.26.
//

import SwiftUI
import AppFoundation
import Clubs
import AppUIKit

struct CommunityDetailView: View {
    @ObservedObject var store: StoreOf<CommunityDetailFeature>
    
    @State private var isScrolled = false
    @State private var isNameVisible = true
    @State private var isSegmentSticky = false
    @State private var baseHeight: CGFloat = 164
    @State private var navBarHeight: CGFloat = 0
    @State private var tabHeights: [CommunityDetailViewState.SegmentTypes: CGFloat] = [:]
    
    private let clubsModule: ClubsModule
    
    init(
        store: StoreOf<CommunityDetailFeature>,
        clubsModule: ClubsModule = resolve()
    ) {
        self.clubsModule = clubsModule
        self.store = store
    }
    
    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .top) {
                mainScrollView(proxy)
                navigationOverlay(safeAreaTop: proxy.safeAreaInsets.top)
            }
            .ignoresSafeArea()
            .toolbar(.hidden)
            .enableSwipeBack()
            .onGeometryChange(for: CGFloat.self) { $0.size.height } action: { newValue in
                baseHeight = newValue / 4.5
            }
        }
        .animation(.easeInOut, value: store.state.selectedSegment)
        .onAppear {
            store.send(.fetchData)
        }
    }
    
    // MARK: - Main Components
    
    private func mainScrollView(_ proxy: GeometryProxy) -> some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: .zero) {
                stretchableHeader
                logoView
                bottomView
            }
        }
        .coordinateSpace(name: "scroll")
    }
    
    private func navigationOverlay(safeAreaTop: CGFloat) -> some View {
        VStack(spacing: 0) {
            customNavigationBar(safeAreaTop: safeAreaTop)
                .background(isScrolled ? Color.white : Color.clear)
                .clipShape(RoundedRectangle(cornerRadius: .zero))
                .shadow(
                    color: isScrolled ? Color.black.opacity(0.1) : Color.clear,
                    radius: isScrolled ? 4 : 0,
                    x: 0,
                    y: isScrolled ? 2 : 0
                )
            
            if isSegmentSticky {
                segmentViewSticky
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.2), value: isScrolled)
        .animation(.easeInOut(duration: 0.2), value: isSegmentSticky)
    }
    
    // MARK: - Navigation Bar
    
    private func customNavigationBar(safeAreaTop: CGFloat) -> some View {
        HStack {
            Button { store.send(.backTapped) } label: {
                navigationBarButton(uiImage: UIImage.Icons.arrowLeft01)
            }
            
            Spacer()
            
            HStack(spacing: 12) {
                Button {} label: {
                    navigationBarButton(uiImage: UIImage.Icons.ellipsis02)
                }
                
                if !isScrolled {
                    Button {} label: {
                        navigationBarButton(uiImage: UIImage.Icons.camera)
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, safeAreaTop - 5)
        .overlay(navBarTitleOverlay(safeAreaTop: safeAreaTop))
        .onGeometryChange(for: CGFloat.self) { $0.size.height } action: { newValue in
            navBarHeight = newValue - 20
        }
    }
    
    private func navBarTitleOverlay(safeAreaTop: CGFloat) -> some View {
        Group {
            if !isNameVisible {
                Text(store.state.uiModel?.name ?? "")
                    .font(Font.Typography.HeadingXl.bold)
                    .lineLimit(1)
                    .padding(.horizontal, 80)
                    .padding(.top, safeAreaTop - 16)
            }
        }
    }
    
    private func navigationBarButton(uiImage: UIImage) -> some View {
        Image(uiImage: uiImage)
            .padding(10)
            .background(isScrolled ? Color.Palette.grayQuaternary : Color.Palette.whiteMedium)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.bottom, 16)
    }
    
    // MARK: - Header
    
    private var stretchableHeader: some View {
        GeometryReader { geo in
            let minY = geo.frame(in: .named("scroll")).minY
            let pullDown = max(minY, 0)
            let height = baseHeight + pullDown
            let scale = 1 + (pullDown / 350)

            headerContent
                .frame(height: height)
                .scaleEffect(scale, anchor: .center)
                .clipped()
                .offset(y: minY > 0 ? -minY : 0)
                .onChange(of: minY) { newValue in
                    withAnimation {
                        isScrolled = newValue < -30
                    }
                }
        }
        .frame(height: baseHeight)
    }
    
    private var headerContent: some View {
        CachedAsyncImage(url: store.state.uiModel?.coverImage) { image in
            image.resizable()
        } placeholder: {
            CardBackgroundView(cardType: .club) {}
                .backgroundType(store.state.uiModel?.coverColorType ?? .primary)
                .cornerRadius(.zero)
        }
    }
    
    // MARK: - Logo
    
    private var logoView: some View {
        HStack(alignment: .lastTextBaseline) {
            clubLogo
            Spacer()
            Button {} label: {
                Image(uiImage: UIImage.Icons.penLine)
            }
            .padding(.horizontal)
        }
        .padding(.top, -44)
        .padding(.bottom, 16)
    }
    
    private var clubLogo: some View {
        CachedAsyncImage(url: store.state.uiModel?.logo) { image in
            image.resizable().frame(width: 88, height: 88)
        } placeholder: {
            if let image = UIImage(systemName: "person") {
                Image(uiImage: image)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(Color.Palette.blackMedium)
                    .frame(width: 44, height: 44)
            }
        }
        .frame(width: 88, height: 88)
        .background(Color.Palette.grayQuaternary)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.Palette.grayTeritary.opacity(0.3), lineWidth: 3)
        )
        .padding(.horizontal, 16)
        .overlay(alignment: .bottomTrailing) {
            cameraButton
        }
    }
    
    private var cameraButton: some View {
        Button {} label: {
            Image(uiImage: UIImage.Icons.camera)
                .resizable()
                .renderingMode(.template)
                .frame(width: 18, height: 18)
                .foregroundStyle(Color.Palette.blackMedium)
                .padding(7)
                .background(Color.Palette.grayQuaternary)
                .clipShape(Circle())
                .overlay(
                    Circle().stroke(Color.Palette.whiteHigh, lineWidth: 2)
                )
        }
    }
    
    // MARK: - Bottom Content
    
    private var bottomView: some View {
        VStack(alignment: .leading, spacing: 0) {
            clubInfoView
            segmentView
            tabView
        }
        .padding(.horizontal)
    }
    
    private var clubInfoView: some View {
        VStack(alignment: .leading, spacing: 8) {
            clubNameText
            memberCount
            chipsView
            createEventButton
        }
    }
    
    private var clubNameText: some View {
        Text(store.state.uiModel?.name ?? "")
            .font(Font.Typography.TitleL.extraBold)
            .frame(maxWidth: .infinity, alignment: .leading)
            .onGeometryChange(for: CGFloat.self) {
                $0.frame(in: .named("scroll")).minY
            } action: { minY in
                withAnimation {
                    isNameVisible = minY > navBarHeight
                }
            }
    }
    
    private var memberCount: some View {
        Text("\(store.state.uiModel?.membersCount ?? 0) members")
            .font(Font.Typography.TextMd.regular)
            .foregroundStyle(Color.Palette.blackHigh)
    }
    
    private var chipsView: some View {
        let tags = store.state.uiModel?.tags ?? []
        return FlowLayout(items: tags) { item in
            Text("#\(item.title.lowercased())")
                .font(Font.Typography.TextSm.regular)
                .lineLimit(1)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.Palette.grayQuaternary)
                .clipShape(Capsule())
        }
    }
    
    private var createEventButton: some View {
        AppButton(
            title: "Create new event +",
            model: .init(
                type: .secondary,
                contentSize: .fill,
                size: .medium
            )
        ) {}
    }
    
    // MARK: - Segments
    
    @ViewBuilder
    private var segmentView: some View {
        segmentPicker
            .padding(.top)
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
            tabContent(for: .about, content: infoTab)
            tabContent(for: .clubs, content: clubsTab)
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(height: tabHeights[store.state.selectedSegment] ?? 300)
        .animation(.spring(response: 0.1, dampingFraction: 1), value: tabHeights[store.state.selectedSegment])
        .onPreferenceChange(TabHeightPreferenceKey.self) { heights in
            tabHeights.merge(heights) { _, new in new }
        }
    }
    
    private func tabContent<Content: View>(
        for segment: CommunityDetailViewState.SegmentTypes,
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
    
    @ViewBuilder
    private var infoTab: some View {
        let infoData = store.state.uiModel?.infoData ?? []
        VStack(alignment: .leading, spacing: 16) {
            ForEach(infoData, id: \.id) { item in
                AppInfoContainer(spacing: 10) {
                    Text(item.title)
                        .font(Font.Typography.HeadingMd.medium)
                        .foregroundStyle(Color.Palette.blackHigh)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    ForEach(item.subItems, id: \.id) { subItem in
                        infoSubItem(subItem)
                    }
                }
            }
        }
        .padding(.top)
        .padding(.bottom, 60)
        .padding(.horizontal, 4)
    }
    
    private func infoSubItem(_ subItem: CommunityDetails.SubInfo) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            if let title = subItem.title {
                Text(title)
                    .font(Font.Typography.TextMd.regular)
                    .foregroundStyle(Color.Palette.blackMedium)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            Text(subItem.description)
                .font(Font.Typography.BodyTextSm.regular)
                .foregroundStyle(
                    subItem.isLink ? Color.Palette.appBlue : Color.Palette.blackHigh
                )
                .fixedSize(horizontal: false, vertical: true)
        }
    }
    
    private var clubsTab: some View {
        VStack(spacing: 0) {
            let clubs = store.state.uiModel?.clubsData ?? []
            if !clubs.isEmpty {
                VStack(spacing: 16) {
                    ForEach(clubs, id: \.uuid) { item in
                        if let view = clubsModule.makeCardView(
                            inputData: item,
                            onTap: {
                                store.send(.clubItemTapped(item.id))
                            }
                        ) as? AnyView {
                            view
                        }
                    }
                }
            } else {
                emptyView(
                    icon: UIImage.Icons.twoUsers,
                    text: "There are no clubs for this community yet. Be the pioneer and start the very first one now!",
                    buttonTitle: "Create a club +",
                    type: .clubs
                )
                .padding()
            }
        }
        .padding(.top)
    }
    
    private func emptyView(
        icon: UIImage,
        text: String,
        buttonTitle: String,
        type: AppUIEntities.ActivityType
    ) -> some View {
        AppEmptyView(
            model: .init(
                icon: icon,
                text: text,
                buttonTitle: buttonTitle
            )
        ) {
            
        }
        .padding()
    }
}
