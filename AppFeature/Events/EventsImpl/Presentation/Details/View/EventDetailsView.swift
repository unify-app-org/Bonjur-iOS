//
//  EventDetailsView.swift
//  EventsImpl
//
//  Created by Huseyn Hasanov on 01.02.26.
//

import Clubs
import SwiftUI
import AppUIKit
import AppFoundation
import Communities

struct EventDetailsView: View {
    @ObservedObject var store: StoreOf<EventDetailsFeature>
    
    @State private var isScrolled = false
    @State private var isNameVisible = true
    @State private var isSegmentSticky = false
    @State private var baseHeight: CGFloat = 164
    @State private var tabHeights: [EventDetailsViewState.SegmentTypes: CGFloat] = [:]
    
    private let clubsModule: ClubsModule
    private let communitiesModule: CommunitiesModule
    
    init(
        store: StoreOf<EventDetailsFeature>,
        clubsModule: ClubsModule = resolve(),
        communitiesModule: CommunitiesModule = resolve()
    ) {
        self.clubsModule = clubsModule
        self.communitiesModule = communitiesModule
        self.store = store
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            mainScrollView
                .ignoresSafeArea(edges: .top)
            
            if isSegmentSticky {
                segmentViewSticky
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .onGeometryChange(for: CGFloat.self) { $0.size.height } action: { newValue in
            baseHeight = newValue / 4
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbarRole(.editor)
        .toolbarBackground(isScrolled ? .automatic : .hidden, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Image(uiImage: UIImage.Icons.arrowLeft01)
                    .toolbarItemBackground(
                        isScrolled: isScrolled
                    ) {
                        store.send(.backTapped)
                    }
            }
            ToolbarItem(placement: .principal) {
                if !isNameVisible {
                    Text(store.state.uiModel?.name ?? "")
                        .font(Font.Typography.HeadingXl.bold)
                        .lineLimit(1)
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Image(uiImage: UIImage.Icons.ellipsis02)
                    .toolbarItemBackground(
                        isScrolled: isScrolled
                    ) {
                        
                    }
            }
            if !isScrolled {
                ToolbarItem(placement: .topBarTrailing) {
                    Image(uiImage: UIImage.Icons.camera)
                        .toolbarItemBackground(
                            isScrolled: isScrolled
                        ) {
                            
                        }
                }
            }
        }
        .enableSwipeBack()
        .animation(.easeInOut, value: store.state.selectedSegment)
        .animation(.easeInOut(duration: 0.2), value: isSegmentSticky)
        .onAppear {
            store.send(.fetchData)
        }
    }
    
    // MARK: - Main Components
    
    private var mainScrollView: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: .zero) {
                    stretchableHeader
                    bottomView
                }
            }
            .coordinateSpace(name: "scroll")
            
            AppButton(
                title: "Join",
                model: .init(
                    contentSize: .fill
                )
            ) {
                
            }
            .padding(.horizontal)
        }
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
        VStack(alignment: .leading, spacing: 16) {
            clubNameText
            clubMetadata
            memberCount
            VStack(spacing: 8) {
                chipsView
                remindButton
            }
            attachmentsView
        }
        .padding(.top)
    }
    
    private var attachmentsView: some View {
        VStack(alignment: .leading, spacing: 16) {
            let attachments = store.state.uiModel?.attachments ?? []
            VStack(alignment: .leading, spacing: 8) {
                Text("Attachments")
                    .font(Font.Typography.HeadingXl.medium)
                    .foregroundStyle(Color.Palette.black)
                    .frame(alignment: .leading)
                    .multilineTextAlignment(.leading)
                if !attachments.isEmpty {
                    Text("You can upload files up to 15 MB total for this event.")
                        .font(Font.Typography.BodyTextSm.regular)
                        .foregroundStyle(Color.Palette.blackMedium)
                        .frame(alignment: .leading)
                        .multilineTextAlignment(.leading)
                }
            }
            if !attachments.isEmpty {
                ForEach(attachments, id: \.uuid) { attachment in
                    AttachmentItemView(model: attachment)
                }
                if !store.state.isFileUploadReachedMaxLimit {
                    AppButton(
                        title: "Add +",
                        model: .init(
                            type: .secondary,
                            contentSize: .fill,
                            size: .small,
                        )
                    ) {
                        
                    }
                }
            } else {
                AppEmptyView(model:
                        .init(
                            icon: nil,
                            text: "You can upload files up to 15 MB total for this event.",
                            buttonTitle: "Add +"
                        )
                ) {
                    
                }
            }
        }
    }
    
    private var clubNameText: some View {
        HStack {
            Text(store.state.uiModel?.name ?? "")
                .font(Font.Typography.TitleL.extraBold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .onGeometryChange(for: CGFloat.self) {
                    $0.frame(in: .named("scroll")).minY
                } action: { minY in
                    withAnimation {
                        isNameVisible = minY > 0
                    }
                }
            
            Spacer()
            
            Button {
                
            } label: {
                Image(uiImage: UIImage.Icons.penLine)
            }
        }
    }
    
    private var clubMetadata: some View {
        HStack(alignment: .center, spacing: 24) {
            accessTypeBadge
            communityLink
        }
    }
    
    private var accessTypeBadge: some View {
        let isPrivate = store.state.uiModel?.accessType == .private
        return Text(isPrivate ? "Private" : "Public")
            .font(Font.Typography.TextSm.medium)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .foregroundStyle(isPrivate ? Color.Palette.blackHigh : Color.Palette.whiteHigh)
            .background(isPrivate ? Color.Palette.white : Color.Palette.blackHigh)
            .clipShape(Capsule())
            .overlay(
                Capsule().stroke(Color.Palette.blackHigh, lineWidth: 0.5)
            )
    }
    
    private var communityLink: some View {
        Button {} label: {
            Text(store.state.uiModel?.communityName ?? "")
                .font(Font.Typography.TextL.medium)
                .foregroundStyle(Color.Palette.appBlue)
                .underline()
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
    
    private var remindButton: some View {
        AppButton(
            title: "Reminder",
            model: .init(
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
            tabContent(for: .about, content: infoTab)
            tabContent(for: .members, content: membersTab)
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(height: tabHeights[store.state.selectedSegment] ?? 300)
        .animation(.spring(response: 0.1, dampingFraction: 1), value: tabHeights[store.state.selectedSegment])
        .onPreferenceChange(TabHeightPreferenceKey.self) { heights in
            tabHeights.merge(heights) { _, new in new }
        }
    }
    
    private func tabContent<Content: View>(
        for segment: EventDetailsViewState.SegmentTypes,
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
    
    private func infoSubItem(_ subItem: EventsDetailsModel.SubInfo) -> some View {
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

    @ViewBuilder
    private var membersTab: some View {
        if let membersData = store.state.uiModel?.membersData,
           let view = communitiesModule.makeMembersListView(
               input: .init(
                   data: membersData,
                   onOptionsTapped: { _ in },
                   onMemberTapped: { _ in }
               )
           ) as? AnyView {
            view
        } else {
            EmptyView()
        }
    }
}
