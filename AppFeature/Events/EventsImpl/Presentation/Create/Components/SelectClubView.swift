//
//  SelectClubView.swift
//  EventsImpl
//
//  Created by Codex on 08.06.26.
//

import SwiftUI
import AppFoundation
import AppUIKit

struct SelectClubView: View {
    let clubs: [EventsCreate.SelectableClub]
    let selectedClubId: Int?
    let onSelect: (EventsCreate.SelectableClub) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("events_select_club".localized)
                .font(Font.Typography.HeadingXl.bold)
                .foregroundStyle(Color.Palette.blackHigh)
                .padding(.top, 8)

            Text("events_select_club_hint".localized)
                .font(Font.Typography.BodyTextSm.regular)
                .foregroundStyle(Color.Palette.blackMedium)
                .padding(.top, 8)
                .padding(.bottom, 16)

            ScrollView(showsIndicators: false) {
                VStack(spacing: 12) {
                    ForEach(clubs) { club in
                        row(for: club)
                    }
                }
                .padding(.vertical, 4)
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 24)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color.Palette.white)
    }

    private func row(for club: EventsCreate.SelectableClub) -> some View {
        Button {
            onSelect(club)
        } label: {
            HStack(spacing: 16) {
                avatar(for: club)

                VStack(alignment: .leading, spacing: 2) {
                    Text(club.clubName)
                        .font(Font.Typography.BodyTextMd.regular)
                        .foregroundStyle(Color.Palette.blackHigh)

                    Text(club.role.title)
                        .font(Font.Typography.BodyTextSm.regular)
                        .foregroundStyle(Color.Palette.blackMedium)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                radio(isSelected: club.clubId == selectedClubId)
            }
            .padding(12)
            .background(Color.Palette.grayQuaternary.opacity(0.4))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    private func avatar(for club: EventsCreate.SelectableClub) -> some View {
        Group {
            if let url = club.profileURL {
                CachedAsyncImage(url: url) { image in
                    image.resizable().scaledToFill()
                } placeholder: {
                    Color.Palette.grayQuaternary
                }
            } else {
                Color.Palette.grayQuaternary
            }
        }
        .frame(width: 48, height: 48)
        .clipShape(Circle())
    }

    private func radio(isSelected: Bool) -> some View {
        ZStack {
            Circle()
                .stroke(
                    isSelected ? Color.Palette.blackHigh : Color.Palette.grayTeritary,
                    lineWidth: 2
                )
                .frame(width: 22, height: 22)

            if isSelected {
                Circle()
                    .fill(Color.Palette.blackHigh)
                    .frame(width: 12, height: 12)
            }
        }
    }
}
