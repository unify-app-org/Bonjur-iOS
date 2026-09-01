//
//  HangoutDetailsView.swift
//  HangoutsImpl
//
//  Created by Huseyn Hasanov on 02.02.26.
//

import UIKit
import AppUtils
import SwiftUI
import AppFoundation
import AppUIKit
import AppStorage
import AppPresentationModel
import Communities

struct HangoutDetailsView: View {
    @ObservedObject var store: StoreOf<HangoutDetailsFeature>

    @State private var isNameVisible = true
    @State private var isScrolled = false
    @State private var isSegmentSticky = false
    @State private var tabHeights: [HangoutDetailsViewState.SegmentTypes: CGFloat] = [:]
    @State private var optionsMember: CommunitiesMemberModuleModel.MemberCellModel?
    @State private var optionsToken: HangoutOptionsToken?

    private let communitiesModule: CommunitiesModule
    private let keychain: KeychainProtocol

    init(
        store: StoreOf<HangoutDetailsFeature>,
        communitiesModule: CommunitiesModule = resolve(),
        keychain: KeychainProtocol = KeychainImpl()
    ) {
        self.communitiesModule = communitiesModule
        self.keychain = keychain
        self.store = store
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                ScrollView(showsIndicators: false) {
                    contentView
                }
                .coordinateSpace(name: "scroll")
                joinButton
            }
            
            if isSegmentSticky {
                segmentViewSticky
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .appSheet(item: $optionsMember) { member in
            memberOptionsSheet(for: member)
        }
        .appSheet(item: $optionsToken) { _ in
            hangoutOptionsSheet
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
                    ) { optionsToken = HangoutOptionsToken() }
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
    
    @ViewBuilder
    private var joinButton: some View {
        if let button = store.state.uiModel?.joinButton {
            AppButton(
                title: button.title,
                model: .init(
                    contentSize: .fill
                )
            ) {
                store.send(.joinTapped)
            }
            .disabled(button.disabled)
            .padding(.horizontal)
        }
    }
    
    // MARK: - Bottom Content
    
    private var contentView: some View {
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
            chipsView
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
                    var transaction = Transaction(animation: .easeInOut(duration: 0.2))
                    transaction.disablesAnimations = false
                    withTransaction(transaction) {
                        // The big title is the first scroll element, so at rest its
                        // minY ≈ 0. Only treat it as hidden (and reveal the nav-bar
                        // title) once it has scrolled up past ~its own height, so the
                        // two titles never show at the same time.
                        isNameVisible = minY > -36
                        isScrolled = minY <= 0
                    }
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
            store.send(.communityTapped)
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
    
    private var remindButton: some View {
        AppButton(
            title: "hangouts_reminder".localized,
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
        for segment: HangoutDetailsViewState.SegmentTypes,
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

    private func handleTap(on subItem: HangoutDetails.SubInfo) {
        if let phone = subItem.phoneNumber {
            UIPasteboard.general.string = phone
            AppSnackBar.show(title: "common_copied".localized)
        } else if subItem.isLink {
            openLink(subItem.description)
        }
    }

    @ViewBuilder
    private func infoSubItem(_ subItem: HangoutDetails.SubInfo) -> some View {
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

    private func subItemContent(_ subItem: HangoutDetails.SubInfo, isActionable: Bool) -> some View {
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
        if let membersData = store.state.membersData,
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

    private var hangoutOptionsSheet: some View {
        HangoutOptionsSheet(
            input: .init(
                viewerRole: store.state.uiModel?.userActivityType ?? .notJoined,
                onExit: { store.send(.exitTapped) },
                onReport: { _ in
                    await MainActor.run {
                        AppSnackBar.show(title: "hangouts_report_submitted".localized, style: .success)
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
                    AppSnackBar.show(title: "hangouts_report_submitted".localized, style: .success)
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
