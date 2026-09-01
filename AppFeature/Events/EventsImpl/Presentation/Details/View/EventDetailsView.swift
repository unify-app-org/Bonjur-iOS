//
//  EventDetailsView.swift
//  EventsImpl
//
//  Created by Huseyn Hasanov on 01.02.26.
//

import UIKit
import AppUtils
import Clubs
import SwiftUI
import AppUIKit
import AppStorage
import AppPresentationModel
import AppFoundation
import Communities

struct EventDetailsView: View {
    @ObservedObject var store: StoreOf<EventDetailsFeature>

    @State private var isScrolled = false
    @State private var isNameVisible = true
    @State private var isSegmentSticky = false
    @State private var baseHeight: CGFloat = 164
    @State private var tabHeights: [EventDetailsViewState.SegmentTypes: CGFloat] = [:]
    @State private var optionsMember: CommunitiesMemberModuleModel.MemberCellModel?
    @State private var optionsToken: EventOptionsToken?

    private let clubsModule: ClubsModule
    private let communitiesModule: CommunitiesModule
    private let keychain: KeychainProtocol

    init(
        store: StoreOf<EventDetailsFeature>,
        clubsModule: ClubsModule = resolve(),
        communitiesModule: CommunitiesModule = resolve(),
        keychain: KeychainProtocol = KeychainImpl()
    ) {
        self.clubsModule = clubsModule
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
            eventOptionsSheet
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
                        optionsToken = EventOptionsToken()
                    }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Image(uiImage: UIImage.Icons.penLine)
                    .toolbarItemBackground(
                        isScrolled: isScrolled
                    ) {
                        store.send(.editTapped)
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

            if let joinButton = store.state.uiModel?.joinButton {
                AppButton(
                    title: joinButton.title,
                    model: .init(
                        contentSize: .fill
                    )
                ) {
                    store.send(.joinTapped)
                }
                .disabled(joinButton.disabled)
                .padding(.horizontal)
            }
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
            image
                .resizable()
                .scaledToFill()
        } placeholder: {
            CardBackgroundView(cardType: .club) {}
                .backgroundType(store.state.uiModel?.coverColorType ?? .primary)
                .cornerRadius(.zero)
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
                // Reminder is an organizer-only control.
                if isOrganizer {
                    remindButton
                }
            }
            attachmentsView
        }
        .padding(.top)
    }
    
    /// The viewer's role in this event (drives attachment/reminder permissions).
    private var viewerRole: AppPresentationModel.UserActivityRole {
        store.state.uiModel?.userActivityType ?? .notJoined
    }

    /// Members (and organizers) can see attachments; outsiders cannot.
    private var isMember: Bool { viewerRole != .notJoined }

    /// Only organizers (president / vice president / event creator) may add docs
    /// or set reminders.
    private var isOrganizer: Bool {
        [.president, .visePresident, .eventCreator].contains(viewerRole)
    }

    @ViewBuilder
    private var attachmentsView: some View {
        // Attachments (view + add) are hidden from users who aren't members.
        if isMember {
            let attachments = store.state.uiModel?.attachments ?? []
            VStack(alignment: .leading, spacing: 8) {
                Text("events_attachments".localized)
                    .font(Font.Typography.HeadingXl.medium)
                    .foregroundStyle(Color.Palette.black)
                    .frame(alignment: .leading)
                    .multilineTextAlignment(.leading)
                if !attachments.isEmpty {
                    ForEach(attachments, id: \.uuid) { attachment in
                        AttachmentItemView(model: attachment)
                    }
                } else {
                    AppEmptyView(
                        model: .init(
                            icon: nil,
                            text: "events_attachments_empty".localized,
                            // Only organizers can add documents.
                            buttonTitle: isOrganizer ? "events_add_plus".localized : nil
                        )
                    ) {
                        store.send(.editTapped)
                    }
                }
            }
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
        return Text(isPrivate ? "Private".localized : "Public".localized)
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
        Button {
            store.send(.clubTapped)
        } label: {
            Text(store.state.uiModel?.communityName ?? "")
                .font(Font.Typography.TextL.medium)
                .foregroundStyle(Color.Palette.appBlue)
                .underline()
        }
    }
    
    private var memberCount: some View {
        Text("count_members".localized(with: store.state.uiModel?.membersCount ?? 0))
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
    
    /// One reminder per day: once the backend reports `isReminder`, the button
    /// is spent and says so until it resets tomorrow.
    private var isReminderSent: Bool {
        store.state.uiModel?.isReminderSent ?? false
    }

    private var remindButton: some View {
        AppButton(
            title: isReminderSent
                ? "events_reminder_unavailable".localized
                : "events_reminder".localized,
            model: .init(
                contentSize: .fill,
                size: .medium
            )
        ) {
            store.send(.remindTapped)
        }
        .disabled(isReminderSent)
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

    private func openLink(_ string: String) {
        guard let url = string.browsableURL else { return }
        UIApplication.shared.open(url)
    }

    private func handleTap(on subItem: EventsDetailsModel.SubInfo) {
        if let phone = subItem.phoneNumber {
            UIPasteboard.general.string = phone
            AppSnackBar.show(title: "common_copied".localized)
        } else if subItem.isLink {
            openLink(subItem.description)
        }
    }

    @ViewBuilder
    private func infoSubItem(_ subItem: EventsDetailsModel.SubInfo) -> some View {
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

    private func subItemContent(_ subItem: EventsDetailsModel.SubInfo, isActionable: Bool) -> some View {
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
    private var membersTab: some View {
        if let membersData = store.state.uiModel?.membersData,
           let view = communitiesModule.makeMembersListView(
               input: .init(
                   data: membersData,
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

    private var eventOptionsSheet: some View {
        EventOptionsSheet(
            input: .init(
                viewerRole: store.state.uiModel?.userActivityType ?? .notJoined,
                onExit: { store.send(.exitTapped) },
                onReport: { _ in
                    await MainActor.run {
                        AppSnackBar.show(title: "events_report_submitted".localized, style: .success)
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
        let isSelf = member.id == keychain.getString(key: .userId)
        let input = CommunitiesMemberModuleModel.MemberOptionsInput(
            memberName: member.name,
            currentRole: member.role,
            assignableRoles: [],
            showChangeRole: false,
            showReport: AppPresentationModel.MemberOptionsPolicy.canReport(isSelf: isSelf),
            onAssignRole: { _ in false },
            onReport: { _ in
                await MainActor.run {
                    AppSnackBar.show(title: "events_report_submitted".localized, style: .success)
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
