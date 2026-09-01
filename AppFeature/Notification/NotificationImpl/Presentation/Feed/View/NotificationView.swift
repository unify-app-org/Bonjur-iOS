//
//  NotificationView.swift
//  NotificationImpl
//
//  Created by Huseyn Hasanov on 27.06.26.
//

import SwiftUI
import AppFoundation
import AppUIKit

struct NotificationView: View {
    @ObservedObject var store: StoreOf<NotificationFeature>
    @State private var showMarkAllAlert = false

    private let avatarSize: CGFloat = 48
    private let cardRadius: CGFloat = 16

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 12) {
                actionBanner
                feedContent
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            .padding(.bottom, 55)
        }
        .refreshable {
            store.send(.fetchData)
        }
        .background(Color.Palette.grayQuaternary.opacity(0.4))
        .onFirstAppear {
            store.send(.fetchData)
        }
        .navigationTitle("Notification".localized)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showMarkAllAlert = true
                } label: {
                    doubleTick
                }
            }
        }
        .alert("notif_mark_all_title".localized, isPresented: $showMarkAllAlert) {
            Button("common_cancel".localized, role: .cancel) {}
            Button("notif_mark_all_confirm".localized) {
                store.send(.markAllRead)
            }
        } message: {
            Text("notif_mark_all_read".localized)
        }
    }

    private var doubleTick: some View {
        ZStack {
            Image(systemName: "checkmark")
                .offset(x: -4)
            Image(systemName: "checkmark")
                .offset(x: 3)
        }
        .font(.system(size: 14, weight: .semibold))
        .foregroundStyle(Color.Palette.green900)
    }

    // MARK: - Needs your action (banner)

    private var actionBanner: some View {
        Button {
            store.send(.actionBannerTapped)
        } label: {
            HStack(spacing: 12) {
                ZStack {
                    Circle().fill(Color.Palette.green900)
                    Image(systemName: "checkmark")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(Color.Palette.white)
                }
                .frame(width: avatarSize, height: avatarSize)

                VStack(alignment: .leading, spacing: 3) {
                    Text("notif_needs_action".localized)
                        .font(Font.Typography.BodyTextMd.semiBold)
                        .foregroundStyle(Color.Palette.black)
                    // Falls back to the generic prompt at zero, so the row never reads
                    // "0 requests".
                    Text(
                        store.state.pendingActionCount > 0
                        ? "notif_requests_waiting".localized(with: store.state.pendingActionCount)
                        : "notif_action_subtitle_idle".localized
                    )
                    .font(Font.Typography.TextSm.regular)
                    .foregroundStyle(Color.Palette.graySecondary)
                }

                Spacer(minLength: 8)

                if store.state.pendingActionCount > 0 {
                    Circle()
                        .fill(Color.Palette.destructiveRed)
                        .frame(width: 10, height: 10)
                }
                Image(uiImage: .Icons.chevronRight)
                    .renderingMode(.template)
                    .foregroundStyle(Color.Palette.graySecondary)
            }
            .cardStyle(radius: cardRadius)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Feed

    @ViewBuilder
    private var feedContent: some View {
        if !store.state.uiModel.sections.isEmpty {
            feedSections
            if store.state.isLoadingMore {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
            }
        } else {
            switch store.state.phase {
            case .idle, .loading:
                loadingState
            case .failed:
                errorState
            case .loaded:
                emptyState
            }
        }
    }

    private var feedSections: some View {
        ForEach(store.state.uiModel.sections) { section in
            VStack(alignment: .leading, spacing: 12) {
                Text(section.title)
                    .font(Font.Typography.BodyTextMd.semiBold)
                    .foregroundStyle(Color.Palette.black)
                    .padding(.horizontal, 2)
                    .padding(.top, 8)
                ForEach(section.items) { item in
                    feedRow(item)
                        .onAppear { loadMoreIfNeeded(item) }
                }
            }
        }
    }

    private func loadMoreIfNeeded(_ item: NotificationFeedItem) {
        guard store.state.canLoadMore,
              item.id == store.state.uiModel.sections.last?.items.last?.id else { return }
        store.send(.loadMore)
    }

    // MARK: - States

    private var loadingState: some View {
        ProgressView()
            .frame(maxWidth: .infinity)
            .padding(.top, 120)
    }

    private var errorState: some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 28))
                .foregroundStyle(Color.Palette.graySecondary)
            Text("notif_load_fail".localized)
                .font(Font.Typography.BodyTextMd.semiBold)
                .foregroundStyle(Color.Palette.black)
            Button {
                store.send(.retry)
            } label: {
                Text("notif_try_again".localized)
                    .font(Font.Typography.BodyTextMd.semiBold)
                    .foregroundStyle(Color.Palette.green900)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 100)
    }

    private var emptyState: some View {
        VStack(spacing: 8) {
            Image(systemName: "bell")
                .font(.system(size: 30))
                .foregroundStyle(Color.Palette.graySecondary)
            Text("notif_no_notifications".localized)
                .font(Font.Typography.BodyTextMd.semiBold)
                .foregroundStyle(Color.Palette.black)
            Text("notif_empty_desc".localized)
                .font(Font.Typography.TextL.regular)
                .foregroundStyle(Color.Palette.graySecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 100)
        .padding(.horizontal, 32)
    }

    private func feedRow(_ item: NotificationFeedItem) -> some View {
        Button {
            store.send(.itemTapped(id: item.id))
        } label: {
            HStack(alignment: .top, spacing: 12) {
                avatar(item)
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.title)
                        .font(Font.Typography.BodyTextMd.semiBold)
                        .foregroundStyle(Color.Palette.black)
                        .multilineTextAlignment(.leading)
                    Text(item.subtitle)
                        .font(Font.Typography.TextL.regular)
                        .foregroundStyle(Color.Palette.graySecondary)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                    if let note = item.note, !note.isEmpty {
                        noteBox(note)
                    }
                    let time = receivedAt(item)
                    if !time.isEmpty {
                        Text(time)
                            .font(Font.Typography.TextSm.regular)
                            .foregroundStyle(Color.Palette.graySecondary)
                            .padding(.top, 2)
                    }
                }
                Spacer(minLength: 8)

                if item.isUnread {
                    // Same attention dot as the "Needs your action" banner and the
                    // verification row below it — unread used to be a pale green that
                    // read as decoration next to those.
                    Circle()
                        .fill(Color.Palette.destructiveRed)
                        .frame(width: 10, height: 10)
                }
            }
            .cardStyle(radius: cardRadius)
        }
        .buttonStyle(.plain)
    }

    /// Relative "received" stamp. Recomputed at render so a screen left open
    /// doesn't keep showing the value baked in at map time.
    private func receivedAt(_ item: NotificationFeedItem) -> String {
        guard let createdAt = item.createdAt else { return item.timeAgo }
        return RelativeTime.short(from: createdAt)
    }

    @ViewBuilder
    private func avatar(_ item: NotificationFeedItem) -> some View {
        switch item.image {
        case .remote(let url):
            CachedAsyncImage(url: url) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                iconCell(item.type)
            }
            .frame(width: avatarSize, height: avatarSize)
            .clipShape(RoundedRectangle(cornerRadius: 14))
        case .local:
            iconCell(item.type)
        }
    }

    private func iconCell(_ type: NotificationType) -> some View {
        Image(systemName: type.iconSystemName)
            .font(.system(size: 20, weight: .regular))
            .foregroundStyle(type.iconTint)
            .frame(width: avatarSize, height: avatarSize)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(type.iconBackground)
            )
    }

    private func noteBox(_ note: String) -> some View {
        Text(note)
            .font(Font.Typography.TextSm.regular)
            .foregroundStyle(Color.Palette.graySecondary)
            .multilineTextAlignment(.leading)
            .fixedSize(horizontal: false, vertical: true)
            .padding(.horizontal, 10)
            .padding(.vertical, 7)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.Palette.grayQuaternary)
            )
            .padding(.top, 4)
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

// MARK: - Type styling (local icon cells)

private extension NotificationType {
    var iconTint: Color {
        Color.Palette.green900
    }

    var iconBackground: Color {
        switch self {
        case .birthday:
            return Color.Palette.cardBgTeritary.opacity(0.5)
        case .eventReminder, .requestOutcome, .verificationOutcome, .general:
            return Color.Palette.grayQuaternary
        default:
            return Color.Palette.grayQuaternary
        }
    }
}
