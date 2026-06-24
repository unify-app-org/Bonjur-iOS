//
//  ClubDetailsView.swift
//  AppAuth
//
//  Created by Huseyn Hasanov on 29.01.26.
//

import UIKit
import SwiftUI
import AppFoundation
import AppUIKit
import AppStorage
import AppPresentationModel
import Events
import Communities

struct ClubDetailsView: View {
    @ObservedObject var store: StoreOf<ClubDetailsFeature>

    @State private var isScrolled = false
    @State private var isNameVisible = true
    @State private var isSegmentSticky = false
    @State private var baseHeight: CGFloat = 164
    @State private var tabHeights: [ClubDetailsViewState.SegmentTypes: CGFloat] = [:]
    @State private var optionsMember: CommunitiesMemberModuleModel.MemberCellModel?
    @State private var optionsToken: ClubOptionsToken?

    private let eventsModule: EventsModule
    private let communitiesModule: CommunitiesModule
    private let keychain: KeychainProtocol

    init(
        store: StoreOf<ClubDetailsFeature>,
        eventsModule: EventsModule = resolve(),
        communitiesModule: CommunitiesModule = resolve(),
        keychain: KeychainProtocol = KeychainImpl()
    ) {
        self.eventsModule = eventsModule
        self.communitiesModule = communitiesModule
        self.keychain = keychain
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
        .appSheet(item: $optionsMember) { member in
            memberOptionsSheet(for: member)
        }
        .appSheet(item: $optionsToken) { _ in
            clubOptionsSheet
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar(.visible)
        .enableSwipeBack()
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
                    ) { optionsToken = ClubOptionsToken() }
            }
            if store.state.isEditable {
                ToolbarItem(placement: .topBarTrailing) {
                    Image(uiImage: UIImage.Icons.penLine)
                        .toolbarItemBackground(
                            isScrolled: isScrolled
                        ) {
                            store.send(.editTapped)
                        }
                }
            }
        }
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
                    logoView
                    bottomView
                }
            }
            .coordinateSpace(name: "scroll")
            joinButton
        }
    }
    
    @ViewBuilder
    private var joinButton: some View {
        if let button = store.state.uiModel?.joinButton {
            AppButton(
                title: button.title,
                model: .init(
                    contentSize: .fill
                )
            ) {
                store.send(.joinClubTapped)
            }
            .disabled(button.disabled)
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
    
    private var logoView: some View {
        HStack(alignment: .lastTextBaseline) {
            clubLogo
            Spacer()
        }
        .padding(.top, -44)
        .padding(.bottom, 16)
    }
    
    private var clubLogo: some View {
        AvatarView(url: store.state.uiModel?.logo) {
            if let image = UIImage(systemName: "person") {
                Image(uiImage: image)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(Color.Palette.blackMedium)
                    .frame(width: 44, height: 44)
            }
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
            clubMetadata
            memberCount
            chipsView
            verificationView
            createEventButton
        }
    }

    @ViewBuilder
    private var verificationView: some View {
        if store.state.isVerified {
            verifiedBadge
        } else if store.state.showVerifyButton {
            AppButton(
                title: "Request verification from admins",
                model: .init(
                    type: .secondary,
                    contentSize: .fill,
                    size: .medium
                )
            ) {
                store.send(.requestVerificationTapped)
            }
            .disabled(store.state.verifyButtonDisabled)
        }
    }

    private var verifiedBadge: some View {
        HStack(spacing: 6) {
            Image(systemName: "checkmark.seal.fill")
                .font(.system(size: 14, weight: .semibold))
            Text("Verified club")
                .font(Font.Typography.TextSm.medium)
        }
        .foregroundStyle(Color.Palette.appBlue)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var clubNameText: some View {
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
        Text(store.state.uiModel?.communityName ?? "")
            .font(Font.Typography.TextL.medium)
            .foregroundStyle(Color.Palette.blackHigh)
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
    
    @ViewBuilder
    private var createEventButton: some View {
        if store.state.canCreateEvent {
            AppButton(
                title: "Create new event +",
                model: .init(
                    type: .secondary,
                    contentSize: .fill,
                    size: .medium
                )
            ) {}
        }
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
            tabContent(for: .events, content: eventsTab)
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
        for segment: ClubDetailsViewState.SegmentTypes,
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

    private func openLink(_ string: String) {
        guard let url = URL(string: string) else { return }
        UIApplication.shared.open(url)
    }

    private func handleTap(on subItem: ClubsDetailsModel.SubInfo) {
        if let phone = subItem.phoneNumber {
            UIPasteboard.general.string = phone
            AppSnackBar.show(title: "Copied to clipboard")
        } else if subItem.isLink {
            openLink(subItem.description)
        }
    }

    @ViewBuilder
    private func infoSubItem(_ subItem: ClubsDetailsModel.SubInfo) -> some View {
        let isActionable = subItem.isLink || subItem.phoneNumber != nil
        if isActionable {
            Button {
                handleTap(on: subItem)
            } label: {
                subItemContent(subItem, isActionable: true)
            }
            .buttonStyle(RowHighlightButtonStyle())
        } else {
            subItemContent(subItem, isActionable: false)
        }
    }

    private func subItemContent(_ subItem: ClubsDetailsModel.SubInfo, isActionable: Bool) -> some View {
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
                    isActionable ? Color.Palette.appBlue : Color.Palette.blackHigh
                )
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(Rectangle())
    }
    
    @ViewBuilder
    private var eventsTab: some View {
        let events = store.state.eventsData
        if !events.isEmpty {
            VStack(spacing: 20) {
                ForEach(events, id: \.uuid) { item in
                    if let view = eventsModule.makeEventsCard(
                        model: item,
                        onTap: {},
                        onButtonTap: {},
                        onClubTap: nil
                    ) as? AnyView {
                        view
                    }
                }
            }
            .padding(.vertical)
        } else {
            AppEmptyView(
                model: .init(
                    icon: UIImage.Icons.twoUsers,
                    text: "There are no clubs for this community yet. Be the pioneer and start the very first one now!",
                    buttonTitle: "Create a club +"
                )
            ) {}
            .padding()
        }
    }

    @ViewBuilder
    private var membersTab: some View {
        if let clubMembers = store.state.members,
           let view = communitiesModule.makeMembersListView(
               input: .init(
                   data: clubMembers,
                   currentUserId: keychain.getString(key: .userId),
                   onOptionsTapped: { member in
                       optionsMember = member
                   },
                   onMemberTapped: { member in
                       store.send(.userTapped(member.id))
                   },
                   totalCount: store.state.uiModel?.membersCount,
                   onSeeAllTapped: {
                       store.send(.seeAllMembersTapped)
                   }
               )
           ) as? AnyView {
            view
        } else {
            EmptyView()
        }
    }

    @ViewBuilder
    private var clubOptionsSheet: some View {
        ClubOptionsSheet(
            input: .init(
                viewerRole: store.state.uiModel?.userActivityType ?? .notJoined,
                onExit: { store.send(.exitTapped) },
                onReport: { _ in
                    await MainActor.run {
                        AppSnackBar.show(title: "Report submitted", style: .success)
                    }
                    return true
                }
            )
        )
    }

    @ViewBuilder
    private func memberOptionsSheet(
        for member: CommunitiesMemberModuleModel.MemberCellModel
    ) -> some View {
        let viewer = store.state.uiModel?.userActivityType ?? .notJoined
        let isSelf = member.id == keychain.getString(key: .userId)
        let input = CommunitiesMemberModuleModel.MemberOptionsInput(
            memberName: member.name,
            currentRole: member.role,
            assignableRoles: AppPresentationModel.MemberOptionsPolicy
                .assignableRoles(viewer: viewer),
            showChangeRole: AppPresentationModel.MemberOptionsPolicy
                .canChangeRole(viewer: viewer, activity: .clubs, isSelf: isSelf),
            showReport: AppPresentationModel.MemberOptionsPolicy
                .canReport(isSelf: isSelf),
            onAssignRole: { role in
                await MainActor.run {
                    store.send(.assignRole(userId: member.id, role: role))
                }
                return true
            },
            onReport: { _ in
                await MainActor.run {
                    AppSnackBar.show(title: "Report submitted", style: .success)
                }
                return true
            }
        )

        if let sheet = communitiesModule.makeMemberOptionsSheet(input: input) as? AnyView {
            sheet
        } else {
            EmptyView()
        }
    }
}
