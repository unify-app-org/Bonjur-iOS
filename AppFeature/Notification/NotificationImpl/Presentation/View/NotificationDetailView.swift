//
//  NotificationDetailView.swift
//  NotificationImpl
//
//  Created by Huseyn Hasanov on 28.06.26.
//

import SwiftUI
import AppUIKit

/// Modal preview of a single notification: image, title, body, optional note,
/// and one CTA. Actionable notifications (`targetType != .none`) show
/// "Continue" (deep-links to the target); the rest show "Close".
struct NotificationDetailView: View {
    let item: NotificationFeedItem
    let onContinue: () -> Void
    let onClose: () -> Void

    private var isActionable: Bool {
        item.targetType != .none
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    hero
                    Text(item.title)
                        .font(Font.Typography.TitleSm.bold)
                        .foregroundStyle(Color.Palette.black)
                        .multilineTextAlignment(.leading)
                    Text(item.subtitle)
                        .font(Font.Typography.BodyTextMd.regular)
                        .foregroundStyle(Color.Palette.blackMedium)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)
                    if let note = item.note, !note.isEmpty {
                        noteBox(note)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 24)
            }
            cta
        }
        .background(Color.Palette.white.ignoresSafeArea(.container, edges: .bottom))
    }

    // MARK: - Hero image

    @ViewBuilder
    private var hero: some View {
        switch item.image {
        case .remote(let url):
            CachedAsyncImage(url: url) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                localHero
            }
            .frame(maxWidth: .infinity)
            .frame(height: 180)
            .clipShape(RoundedRectangle(cornerRadius: 18))
        case .local:
            localHero
        }
    }

    private var localHero: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.Palette.grayQuaternary)
            Image(systemName: item.type.iconSystemName)
                .font(.system(size: 48, weight: .regular))
                .foregroundStyle(Color.Palette.black)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 160)
    }

    // MARK: - Note

    private func noteBox(_ note: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Note")
                .font(Font.Typography.CaptionMd.medium)
                .foregroundStyle(Color.Palette.graySecondary)
            Text(note)
                .font(Font.Typography.TextL.regular)
                .foregroundStyle(Color.Palette.black)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.Palette.grayQuaternary)
        )
    }

    // MARK: - CTA

    private var cta: some View {
        Button {
            isActionable ? onContinue() : onClose()
        } label: {
            Text(isActionable ? "Continue" : "Close")
                .font(Font.Typography.BodyTextMd.semiBold)
                .foregroundStyle(Color.Palette.green900)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(
                    Capsule().fill(Color.Palette.secondary)
                )
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
        .padding(.bottom, 20)
    }
}
