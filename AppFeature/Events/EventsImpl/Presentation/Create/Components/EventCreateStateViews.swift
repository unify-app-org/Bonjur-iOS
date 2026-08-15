//
//  EventCreateStateViews.swift
//  EventsImpl
//
//  Empty / error states for the create-event screen. `AppEmptyView` only
//  supports one button, so the organizer empty state (which needs both
//  "events_create_club".localized and "events_browse_clubs".localized) is a local view mirroring its style.
//

import SwiftUI
import AppFoundation
import AppUIKit

// MARK: - Empty: no verified club where the user is an organizer

struct EventCreateEmptyView: View {
    let onCreateClub: () -> Void
    let onBrowseClubs: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            Image(uiImage: UIImage.Icons.calendar)
                .padding(12)
                .background(Color.Palette.grayQuaternary)
                .clipShape(RoundedRectangle(cornerRadius: 16))

            Text("events_no_clubs".localized)
                .font(Font.Typography.BodyTextMd.medium)
                .foregroundStyle(Color.Palette.black)

            Text("To create an event you must be a president, vice president, or organizer of a verified club.")
                .font(Font.Typography.BodyTextSm.regular)
                .multilineTextAlignment(.center)
                .foregroundStyle(Color.Palette.blackMedium)

            VStack(spacing: 8) {
                AppButton(
                    title: "events_create_club".localized,
                    model: .init(type: .primary, contentSize: .fill, size: .small),
                    action: onCreateClub
                )
                AppButton(
                    title: "events_browse_clubs".localized,
                    model: .init(type: .secondary, contentSize: .fill, size: .small),
                    action: onBrowseClubs
                )
            }
            .padding(.horizontal, 24)
            .padding(.top, 4)
        }
        .padding(16)
        .background(Color.Palette.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [5, 5]))
                .foregroundStyle(Color.Palette.grayTeritary.opacity(0.3))
        )
    }
}

// MARK: - Error: the eligible-clubs fetch failed

struct EventCreateErrorView: View {
    let onRetry: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            Text("events_your_clubs_load_fail".localized)
                .font(Font.Typography.BodyTextMd.medium)
                .foregroundStyle(Color.Palette.black)

            Text("events_check_connection".localized)
                .font(Font.Typography.BodyTextSm.regular)
                .multilineTextAlignment(.center)
                .foregroundStyle(Color.Palette.blackMedium)

            AppButton(
                title: "events_retry".localized,
                model: .init(type: .secondary, contentSize: .fill, size: .small),
                action: onRetry
            )
            .padding(.horizontal, 24)
            .padding(.top, 4)
        }
        .padding(16)
        .background(Color.Palette.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [5, 5]))
                .foregroundStyle(Color.Palette.grayTeritary.opacity(0.3))
        )
    }
}
