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
                if store.state.uiModel.action.hasActions {
                    actionBanner
                }
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
        .navigationTitle("Notification")
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
        .alert("Mark all as read?", isPresented: $showMarkAllAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Mark all read") {
                store.send(.markAllRead)
            }
        } message: {
            Text("This marks every notification as read.")
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
                    Text("Needs your action")
                        .font(Font.Typography.BodyTextMd.semiBold)
                        .foregroundStyle(Color.Palette.black)
                    Text(bannerSubtitle)
                        .font(Font.Typography.TextSm.regular)
                        .foregroundStyle(Color.Palette.graySecondary)
                }

                Spacer(minLength: 8)

                Circle()
                    .fill(Color.Palette.destructiveRed)
                    .frame(width: 10, height: 10)

                Image(uiImage: .Icons.chevronRight)
                    .renderingMode(.template)
                    .foregroundStyle(Color.Palette.graySecondary)
            }
            .cardStyle(radius: cardRadius)
        }
        .buttonStyle(.plain)
    }

    private var bannerSubtitle: String {
        let action = store.state.uiModel.action
        return "\(action.requests) join requests · \(action.verifications) to verify"
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
            Text("Couldn't load notifications")
                .font(Font.Typography.BodyTextMd.semiBold)
                .foregroundStyle(Color.Palette.black)
            Button {
                store.send(.retry)
            } label: {
                Text("Try again")
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
            Text("No notifications yet")
                .font(Font.Typography.BodyTextMd.semiBold)
                .foregroundStyle(Color.Palette.black)
            Text("Event reminders, request outcomes and more will show up here.")
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
                }
                Spacer(minLength: 8)

                if item.isUnread {
                    Circle()
                        .fill(Color.Palette.secondary)
                        .frame(width: 9, height: 9)
                }
            }
            .cardStyle(radius: cardRadius)
        }
        .buttonStyle(.plain)
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
        case .birthday, .holiday:
            return Color.Palette.cardBgTeritary.opacity(0.5)
        case .eventReminder, .requestOutcome, .verificationOutcome, .general:
            return Color.Palette.grayQuaternary
        }
    }
}
