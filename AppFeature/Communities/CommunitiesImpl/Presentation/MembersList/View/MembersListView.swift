//
//  MembersListView.swift
//  CommunitiesImpl
//
//  Created by Claude on 15.06.26.
//

import SwiftUI
import AppFoundation
import AppUIKit
import AppPresentationModel
import Communities

struct MembersListView: View {
    @ObservedObject var store: StoreOf<MembersListFeature>

    @State private var optionsMember: CommunitiesMemberModuleModel.MemberCellModel?

    var body: some View {
        VStack(spacing: 0) {
            SearchView(
                text: Binding(
                    get: { store.state.searchText },
                    set: { store.send(.searchChanged($0)) }
                )
            )
            .padding(.horizontal, 16)
            .padding(.vertical, 12)

            content
        }
        .background(Color.Palette.grayQuaternary.opacity(0.2))
        .appSheet(item: $optionsMember) { member in
            memberOptionsSheet(for: member)
        }
        .navigationTitle(store.state.title)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            store.send(.onAppear)
        }
    }

    private var content: some View {
        ScrollViewReader { proxy in
            scrollContent
                // Replacing the rows (search, reload) leaves the ScrollView at its old
                // offset, which is past the end of a shorter result set — the list reads
                // as blank. Snap back to the top whenever the rows are replaced.
                .onChange(of: store.state.listResetToken) { _ in
                    proxy.scrollTo(Self.topAnchor, anchor: .top)
                }
        }
    }

    private static let topAnchor = "members-list-top"

    private var scrollContent: some View {
        ScrollView(showsIndicators: false) {
            Color.clear
                .frame(height: 0)
                .id(Self.topAnchor)

            if store.state.isLoading && store.state.sections.isEmpty {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .padding(.top, 40)
            } else if store.state.isEmpty {
                emptyStateView
            } else {
                MemberListView(
                    sections: store.state.sections,
                    onRowTap: { store.send(.memberTapped($0)) },
                    onAccessoryTap: { row in
                        guard store.state.optionsConfig != nil else { return }
                        optionsMember = row.member
                    },
                    onSelectGroupTap: { _ in },
                    showsScrollView: false,
                    previewLimit: nil,
                    onReachEnd: { store.send(.loadMore) },
                    reachEndToken: store.state.pagesLoaded
                )

                if store.state.hasMore {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                }
            }
        }
    }

    @ViewBuilder
    private func memberOptionsSheet(
        for member: CommunitiesMemberModuleModel.MemberCellModel
    ) -> some View {
        if let config = store.state.optionsConfig {
            let isSelf = member.id == config.currentUserId
            MemberOptionsSheet(
                input: .init(
                    memberName: member.name,
                    currentRole: member.role,
                    assignableRoles: AppPresentationModel.MemberOptionsPolicy
                        .assignableRoles(viewer: config.viewerRole),
                    showChangeRole: AppPresentationModel.MemberOptionsPolicy
                        .canChangeRole(viewer: config.viewerRole, activity: config.activity, isSelf: isSelf),
                    showReport: AppPresentationModel.MemberOptionsPolicy
                        .canReport(isSelf: isSelf),
                    onAssignRole: { role in
                        let ok = await config.onAssignRole(member.id, role)
                        if ok {
                            await MainActor.run { store.send(.reload) }
                        }
                        return ok
                    },
                    onReport: { reason in
                        await config.onReport(member.id, reason)
                    }
                )
            )
        } else {
            EmptyView()
        }
    }

    private var emptyStateView: some View {
        Text(store.state.searchText.isEmpty ? "comm_no_members_yet".localized : "comm_no_members_found".localized)
            .font(Font.Typography.BodyTextSm.regular)
            .foregroundStyle(Color.Palette.blackMedium)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding(.top, 40)
    }
}
