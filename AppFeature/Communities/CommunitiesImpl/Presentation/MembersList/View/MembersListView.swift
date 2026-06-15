//
//  MembersListView.swift
//  CommunitiesImpl
//
//  Created by Claude on 15.06.26.
//

import SwiftUI
import AppFoundation
import AppUIKit
import Communities

struct MembersListView: View {
    @ObservedObject var store: StoreOf<MembersListFeature>

    var body: some View {
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
                    onAccessoryTap: { _ in },
                    onSelectGroupTap: { _ in },
                    showsScrollView: false
                )

                if store.state.hasMore {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .onAppear {
                            store.send(.loadMore)
                        }
                }
            }
        }
        .background(Color.Palette.grayQuaternary.opacity(0.2))
        .navigationTitle(store.state.title)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            store.send(.onAppear)
        }
    }

    private var emptyStateView: some View {
        Text("No members yet")
            .font(Font.Typography.BodyTextSm.regular)
            .foregroundStyle(Color.Palette.blackMedium)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding(.top, 40)
    }
}
