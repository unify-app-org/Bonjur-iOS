//
//  VerificationView.swift
//  NotificationImpl
//
//  Created by Huseyn Hasanov on 28.06.26.
//

import SwiftUI
import AppFoundation
import AppUIKit

struct VerificationView: View {
    @ObservedObject var store: StoreOf<VerificationFeature>

    private let avatarSize: CGFloat = 48
    private let cardRadius: CGFloat = 16

    var body: some View {
        content
            .background(Color.Palette.grayQuaternary.opacity(0.4))
            .navigationTitle("Verifications")
            .navigationBarTitleDisplayMode(.inline)
            .onFirstAppear { store.send(.onAppear) }
    }

    @ViewBuilder
    private var content: some View {
        if !store.state.items.isEmpty {
            list
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

    private var list: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 12) {
                ForEach(store.state.items) { item in
                    row(item)
                        .onAppear { loadMoreIfNeeded(item) }
                }
                if store.state.isLoadingMore {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 32)
        }
        .refreshable { store.send(.refresh) }
    }

    private func loadMoreIfNeeded(_ item: VerificationItem) {
        guard store.state.canLoadMore, item.id == store.state.items.last?.id else { return }
        store.send(.loadMore)
    }

    private func row(_ item: VerificationItem) -> some View {
        let isProcessing = store.state.processingIds.contains(item.id)
        return VStack(alignment: .leading, spacing: 12) {
            Button {
                store.send(.cellTapped(item))
            } label: {
                HStack(spacing: 12) {
                    logo(item)
                    VStack(alignment: .leading, spacing: 4) {
                        Text(item.clubName)
                            .font(Font.Typography.BodyTextMd.semiBold)
                            .foregroundStyle(Color.Palette.black)
                        Text("Submitted by \(item.submitterName)")
                            .font(Font.Typography.TextL.regular)
                            .foregroundStyle(Color.Palette.graySecondary)
                    }
                    Spacer(minLength: 8)
                    Image(uiImage: .Icons.chevronRight)
                        .renderingMode(.template)
                        .foregroundStyle(Color.Palette.graySecondary)
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            actionButtons(item, isProcessing: isProcessing)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: cardRadius)
                .fill(Color.Palette.white)
                .shadow(color: .black.opacity(0.04), radius: 6, y: 3)
        )
        .overlay(
            RoundedRectangle(cornerRadius: cardRadius)
                .stroke(Color.Palette.onBackground, lineWidth: 1)
        )
    }

    @ViewBuilder
    private func actionButtons(_ item: VerificationItem, isProcessing: Bool) -> some View {
        if isProcessing {
            HStack { Spacer(); ProgressView(); Spacer() }
                .frame(height: 44)
        } else {
            HStack(spacing: 10) {
                AppButton(
                    title: "Reject",
                    model: .init(type: .destructive, contentSize: .fill, size: .small)
                ) {
                    store.send(.reject(item))
                }
                AppButton(
                    title: "Verify",
                    model: .init(type: .primary, contentSize: .fill, size: .small)
                ) {
                    store.send(.verify(item))
                }
            }
        }
    }

    @ViewBuilder
    private func logo(_ item: VerificationItem) -> some View {
        if let urlString = item.logoURL, let url = URL(string: urlString) {
            CachedAsyncImage(url: url) { image in
                image.resizable().scaledToFill()
            } placeholder: {
                logoFallback
            }
            .frame(width: avatarSize, height: avatarSize)
            .clipShape(RoundedRectangle(cornerRadius: 14))
        } else {
            logoFallback
        }
    }

    private var logoFallback: some View {
        Image(systemName: "checkmark.seal")
            .font(.system(size: 22))
            .foregroundStyle(Color.Palette.green900)
            .frame(width: avatarSize, height: avatarSize)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.Palette.grayQuaternary)
            )
    }

    // MARK: - States

    private var loadingState: some View {
        VStack { Spacer(); ProgressView(); Spacer() }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var errorState: some View {
        VStack(spacing: 12) {
            Spacer()
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 28))
                .foregroundStyle(Color.Palette.graySecondary)
            Text("Couldn't load verifications")
                .font(Font.Typography.BodyTextMd.semiBold)
                .foregroundStyle(Color.Palette.black)
            Button { store.send(.retry) } label: {
                Text("Try again")
                    .font(Font.Typography.BodyTextMd.semiBold)
                    .foregroundStyle(Color.Palette.green900)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 32)
    }

    private var emptyState: some View {
        VStack(spacing: 8) {
            Spacer()
            Image(systemName: "checkmark.seal.fill")
                .font(.system(size: 30))
                .foregroundStyle(Color.Palette.green900)
            Text("Nothing to verify")
                .font(Font.Typography.BodyTextMd.semiBold)
                .foregroundStyle(Color.Palette.black)
            Text("All club verification requests are handled.")
                .font(Font.Typography.TextL.regular)
                .foregroundStyle(Color.Palette.graySecondary)
                .multilineTextAlignment(.center)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 32)
    }
}
