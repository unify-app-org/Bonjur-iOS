//
//  NeedsActionView.swift
//  NotificationImpl
//
//  Created by Huseyn Hasanov on 28.06.26.
//

import SwiftUI
import AppFoundation
import AppUIKit

struct NeedsActionView: View {
    @ObservedObject var store: StoreOf<NeedsActionFeature>

    private let avatarSize: CGFloat = 48
    private let cardRadius: CGFloat = 16

    var body: some View {
        VStack(spacing: 0) {
            if store.state.isAdmin {
                verificationBanner
            }
            // Pending count per tab, always shown — "Clubs (0)" when there is nothing.
            CapsuleSegmentedPicker(selection: tabSelection) { tab in
                let count = switch tab {
                case .clubs: store.state.clubs.items.count
                case .hangouts: store.state.hangouts.items.count
                case .events: store.state.events.items.count
                }
                return "\(tab.rawValue.localized) (\(count))"
            }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
            pager
        }
        .background(Color.Palette.grayQuaternary.opacity(0.4))
        .navigationTitle("notif_needs_action".localized)
        .navigationBarTitleDisplayMode(.inline)
        .onFirstAppear {
            store.send(.onAppear)
        }
    }

    // MARK: - Verification banner (admin only)

    private var verificationBanner: some View {
        Button {
            store.send(.verificationTapped)
        } label: {
            HStack(spacing: 12) {
                ZStack {
                    Circle().fill(Color.Palette.green900)
                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(Color.Palette.white)
                }
                .frame(width: avatarSize, height: avatarSize)

                VStack(alignment: .leading, spacing: 3) {
                    Text("notif_verification_requests".localized)
                        .font(Font.Typography.BodyTextMd.semiBold)
                        .foregroundStyle(Color.Palette.black)
                    Text("notif_clubs_awaiting_approval".localized(with: store.state.verificationCount))
                        .font(Font.Typography.TextSm.regular)
                        .foregroundStyle(Color.Palette.graySecondary)
                }

                Spacer(minLength: 8)

                if store.state.verificationCount > 0 {
                    Circle()
                        .fill(Color.Palette.destructiveRed)
                        .frame(width: 10, height: 10)
                }
                Image(uiImage: .Icons.chevronRight)
                    .renderingMode(.template)
                    .foregroundStyle(Color.Palette.graySecondary)
            }
            .cardStyle(radius: cardRadius)
            .padding(.horizontal, 16)
            .padding(.top, 12)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Top tabs + pager

    /// Capsule labels drive `selectedTab` directly.
    private var tabSelection: Binding<ActionTab> {
        Binding(
            get: { store.state.selectedTab },
            set: { store.send(.selectTab($0)) }
        )
    }

    /// Bridges the pager's `Int` page index to `selectedTab` so swipe and the
    /// capsule picker stay in sync.
    private var pageIndex: Binding<Int> {
        Binding(
            get: { ActionTab.allCases.firstIndex(of: store.state.selectedTab) ?? 0 },
            set: { index in
                let tabs = ActionTab.allCases
                guard tabs.indices.contains(index) else { return }
                store.send(.selectTab(tabs[index]))
            }
        )
    }

    private var pager: some View {
        AppTabView(
            currentPage: pageIndex,
            pageCount: ActionTab.allCases.count,
            dismissIndicator: false
        ) {
            ForEach(Array(ActionTab.allCases.enumerated()), id: \.element) { index, tab in
                pageView(for: tab)
                    .tag(index)
            }
        }
    }

    @ViewBuilder
    private func pageView(for tab: ActionTab) -> some View {
        switch tab {
        case .events:
            requestsTab(tab: .events, source: store.state.events, emptySubtitle: "No pending event requests right now.")
        case .hangouts:
            requestsTab(tab: .hangouts, source: store.state.hangouts, emptySubtitle: "No pending hangout requests right now.")
        case .clubs:
            requestsTab(tab: .clubs, source: store.state.clubs, emptySubtitle: "No pending club requests right now.")
        }
    }

    // MARK: - Requests tab

    @ViewBuilder
    private func requestsTab(tab: ActionTab, source: RequestSourceState, emptySubtitle: String) -> some View {
        if !source.items.isEmpty {
            requestsList(tab: tab, source: source)
        } else {
            switch source.phase {
            case .idle, .loading:
                loadingState
            case .failed:
                errorState(tab: tab)
            case .loaded:
                comingSoon(title: "notif_all_caught_up".localized, subtitle: emptySubtitle)
            }
        }
    }

    private func requestsList(tab: ActionTab, source: RequestSourceState) -> some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 12) {
                ForEach(source.items) { item in
                    requestRow(item)
                        .onAppear { loadMoreIfNeeded(item, tab: tab, source: source) }
                }
                if source.isLoadingMore {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 32)
        }
        .refreshable {
            store.send(.refresh(tab))
        }
    }

    private func loadMoreIfNeeded(_ item: ActionRequestItem, tab: ActionTab, source: RequestSourceState) {
        guard source.canLoadMore, item.id == source.items.last?.id else { return }
        store.send(.loadMore(tab))
    }

    private func requestRow(_ item: ActionRequestItem) -> some View {
        let isProcessing = store.state.processingIds.contains(item.id)
        return VStack(alignment: .leading, spacing: 10) {
            Button {
                store.send(.requestTapped(item))
            } label: {
                HStack(alignment: .center, spacing: 12) {
                    avatar(item)
                    VStack(alignment: .leading, spacing: 4) {
                        Text(item.requesterName)
                            .font(Font.Typography.BodyTextMd.semiBold)
                            .foregroundStyle(Color.Palette.black)
                            .multilineTextAlignment(.leading)
                        Text(item.targetName)
                            .font(Font.Typography.TextL.regular)
                            .foregroundStyle(Color.Palette.graySecondary)
                            .multilineTextAlignment(.leading)
                    }
                    Spacer(minLength: 8)
                    Image(uiImage: .Icons.chevronRight)
                        .renderingMode(.template)
                        .foregroundStyle(Color.Palette.graySecondary)
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            if !item.timeAgo.isEmpty {
                Text(item.timeAgo)
                    .font(Font.Typography.TextSm.regular)
                    .foregroundStyle(Color.Palette.graySecondary)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            actionButtons(item, isProcessing: isProcessing)
        }
        .cardStyle(radius: cardRadius)
    }

    @ViewBuilder
    private func actionButtons(_ item: ActionRequestItem, isProcessing: Bool) -> some View {
        if isProcessing {
            HStack {
                Spacer()
                ProgressView()
                Spacer()
            }
            .frame(height: 44)
        } else {
            HStack(spacing: 10) {
                AppButton(
                    title: "notif_reject".localized,
                    model: .init(type: .destructive, contentSize: .fill, size: .small)
                ) {
                    store.send(.reject(item))
                }
                AppButton(
                    title: "notif_accept".localized,
                    model: .init(type: .primary, contentSize: .fill, size: .small)
                ) {
                    store.send(.accept(item))
                }
            }
        }
    }

    @ViewBuilder
    private func avatar(_ item: ActionRequestItem) -> some View {
        if let urlString = item.avatarURL, let url = URL(string: urlString) {
            CachedAsyncImage(url: url) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                avatarFallback
            }
            .frame(width: avatarSize, height: avatarSize)
            .clipShape(RoundedRectangle(cornerRadius: 14))
        } else {
            avatarFallback
        }
    }

    private var avatarFallback: some View {
        Image(systemName: "person.crop.circle.fill")
            .font(.system(size: 24, weight: .regular))
            .foregroundStyle(Color.Palette.graySecondary)
            .frame(width: avatarSize, height: avatarSize)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.Palette.grayQuaternary)
            )
    }

    // MARK: - States

    private var loadingState: some View {
        VStack {
            Spacer()
            ProgressView()
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func errorState(tab: ActionTab) -> some View {
        VStack(spacing: 12) {
            Spacer()
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 28))
                .foregroundStyle(Color.Palette.graySecondary)
            Text("notif_requests_load_fail".localized)
                .font(Font.Typography.BodyTextMd.semiBold)
                .foregroundStyle(Color.Palette.black)
            Button {
                store.send(.retry(tab))
            } label: {
                Text("notif_try_again".localized)
                    .font(Font.Typography.BodyTextMd.semiBold)
                    .foregroundStyle(Color.Palette.green900)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 32)
    }

    private func comingSoon(title: String, subtitle: String) -> some View {
        VStack(spacing: 8) {
            Spacer()
            Image(systemName: "tray")
                .font(.system(size: 30))
                .foregroundStyle(Color.Palette.graySecondary)
            Text(title)
                .font(Font.Typography.BodyTextMd.semiBold)
                .foregroundStyle(Color.Palette.black)
            Text(subtitle)
                .font(Font.Typography.TextL.regular)
                .foregroundStyle(Color.Palette.graySecondary)
                .multilineTextAlignment(.center)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 32)
    }
}

// MARK: - Card style

private extension View {
    func cardStyle(radius: CGFloat) -> some View {
        self
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: radius)
                    .fill(Color.Palette.white)
                    .shadow(color: .black.opacity(0.04), radius: 6, y: 3)
            )
            .overlay(
                RoundedRectangle(cornerRadius: radius)
                    .stroke(Color.Palette.onBackground, lineWidth: 1)
            )
    }
}
