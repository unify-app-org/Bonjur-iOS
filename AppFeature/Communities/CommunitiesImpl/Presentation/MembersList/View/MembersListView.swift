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
        ScrollView(showsIndicators: false) {
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
                    previewLimit: nil
                )

                if store.state.hasMore {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        // Re-identify per page: a single spinner instance only fires
                        // `onAppear` once, which stalled paging after the 2nd page.
                        .id(store.state.loadedCount)
                        .onAppear {
                            store.send(.loadMore)
                        }
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
