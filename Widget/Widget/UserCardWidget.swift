//
//  UserCardWidget.swift
//  UnifyWidget
//
//  Created by Huseyn Hasanov on 01.09.26.
//

import WidgetKit
import SwiftUI
import AppWidgetShared

struct UserCardWidget: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: UserCardWidgetStore.widgetKind,
            provider: UserCardProvider()
        ) { entry in
            UserCardWidgetView(entry: entry)
                .widgetBackground(WidgetPalette.white)
        }
        .configurationDisplayName("Unify card")
        .description("Your student card, one tap from the home screen.")
        .supportedFamilies([.systemSmall, .systemMedium])
        .contentMarginsDisabled()
    }
}

/// Same card as `UserCardView` in the app: cover-colored background with the
/// `CardBackgroundView` circle, avatar + name + speciality, community badge, the
/// course/degree/entry row, and the email strip under a divider. Only the sizes shrink.
struct UserCardWidgetView: View {
    let entry: UserCardEntry

    @Environment(\.widgetFamily) private var family

    private var cover: WidgetCardCover? {
        entry.snapshot.background.flatMap(WidgetCardCover.init(rawValue:))
    }

    /// Card text color: the cover decides it, exactly like `UserCardView`.
    private var foreground: Color {
        cover?.foregroundColor ?? WidgetPalette.blackHigh
    }

    /// The email strip keeps its own fill — green on the plain white card, the cover
    /// color otherwise (mirrors `emailView`'s `bgColor ?? .primary`).
    private var stripColor: Color {
        cover?.bgColor ?? WidgetPalette.primary
    }

    var body: some View {
        ZStack {
            cardBackground
            content
        }
        // Lands on the user's own profile; the card itself is one tap from there.
        // Uses the existing `bonjur://user` deep link rather than a new route, and
        // falls back to a plain app launch when no id is stored.
        .widgetURL(deepLinkURL)
        .opacity(entry.isSignedIn ? 1 : 0.55)
    }

    private var deepLinkURL: URL? {
        guard entry.isSignedIn, !entry.snapshot.userId.isEmpty else { return nil }
        return URL(string: "bonjur://user?id=\(entry.snapshot.userId)")
    }

    // MARK: - Background

    @ViewBuilder
    private var cardBackground: some View {
        if let cover {
            ZStack {
                cover.bgColor
                // The single off-canvas circle `CardBackgroundView(cardType: .club)` draws.
                GeometryReader { geometry in
                    Circle()
                        .stroke(WidgetPalette.white.opacity(0.5), lineWidth: 28)
                        .frame(
                            width: geometry.size.width * 0.4,
                            height: geometry.size.width * 0.6
                        )
                        .position(
                            x: geometry.size.width * 0.8,
                            y: -geometry.size.width * 0.05
                        )
                }
            }
        } else {
            WidgetPalette.white
        }
    }

    // MARK: - Content

    @ViewBuilder
    private var content: some View {
        switch family {
        case .systemSmall:
            smallBody
        default:
            mediumBody
        }
    }

    private var mediumBody: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top, spacing: 12) {
                avatar(side: 58, cornerRadius: 16)

                VStack(alignment: .leading, spacing: 6) {
                    nameAndSpeciality(nameSize: 16, specialitySize: 12)
                    communityBadge(fontSize: 11)
                }

                Spacer(minLength: 0)
            }
            .padding(.horizontal, 14)
            .padding(.top, 12)

            Spacer(minLength: 6)

            infoRow
                .padding(.horizontal, 14)

            Spacer(minLength: 6)

            emailStrip(fontSize: 11)
        }
    }

    private var smallBody: some View {
        VStack(alignment: .leading, spacing: 0) {
            avatar(side: 40, cornerRadius: 12)
                .padding(.horizontal, 12)
                .padding(.top, 12)

            nameAndSpeciality(nameSize: 13, specialitySize: 10)
                .padding(.horizontal, 12)
                .padding(.top, 8)

            communityBadge(fontSize: 10)
                .padding(.horizontal, 12)
                .padding(.top, 6)

            Spacer(minLength: 4)

            emailStrip(fontSize: 9)
        }
    }

    // MARK: - Pieces

    @ViewBuilder
    private func avatar(side: CGFloat, cornerRadius: CGFloat) -> some View {
        Group {
            if let image = entry.avatar {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                ZStack {
                    WidgetPalette.grayQuaternary
                    Image(systemName: "person.fill")
                        .font(.system(size: side * 0.45))
                        .foregroundStyle(WidgetPalette.blackMedium)
                }
            }
        }
        .frame(width: side, height: side)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(WidgetPalette.blackHigh, lineWidth: 0.5)
        )
    }

    private func nameAndSpeciality(nameSize: CGFloat, specialitySize: CGFloat) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(entry.snapshot.nameSurname)
                .font(.system(size: nameSize, weight: .bold))
                .foregroundStyle(foreground)
                .lineLimit(2)
                .minimumScaleFactor(0.8)

            if !entry.snapshot.speciality.isEmpty {
                Text(entry.snapshot.speciality)
                    .font(.system(size: specialitySize, weight: .medium))
                    .foregroundStyle(foreground)
                    .lineLimit(1)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    @ViewBuilder
    private func communityBadge(fontSize: CGFloat) -> some View {
        if !entry.snapshot.community.isEmpty {
            Text(entry.snapshot.community)
                .font(.system(size: fontSize, weight: .bold))
                .foregroundStyle(WidgetPalette.blackHigh)
                .lineLimit(1)
                .padding(.vertical, 4)
                .padding(.horizontal, 12)
                .background(cover == nil ? WidgetPalette.primary : WidgetPalette.whiteMedium)
                .clipShape(Capsule())
                .overlay(
                    Capsule().stroke(WidgetPalette.grayTertiary, lineWidth: 0.5)
                )
        }
    }

    private var infoRow: some View {
        HStack(alignment: .top, spacing: 8) {
            infoItem(title: "Course", value: entry.snapshot.course)
            Spacer(minLength: 0)
            infoItem(title: "Degree", value: entry.snapshot.degree)
            Spacer(minLength: 0)
            infoItem(title: "Entry", value: entry.snapshot.entryYear)
        }
    }

    private func infoItem(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 1) {
            Text(title)
                .font(.system(size: 9, weight: .regular))
                .foregroundStyle(foreground)
            Text(value.isEmpty ? "—" : value)
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(foreground)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func emailStrip(fontSize: CGFloat) -> some View {
        VStack(spacing: 6) {
            Rectangle()
                .fill(foreground.opacity(0.3))
                .frame(height: 0.5)

            HStack(spacing: 6) {
                Image(systemName: "envelope")
                    .font(.system(size: fontSize, weight: .medium))
                    .foregroundStyle(foreground)
                Text(entry.snapshot.email)
                    .font(.system(size: fontSize, weight: .regular))
                    .foregroundStyle(foreground)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                Spacer(minLength: 0)
            }
            .padding(.horizontal, 14)
        }
        .padding(.bottom, 10)
        .background(stripColor)
    }
}

private extension View {
    /// `containerBackground` is iOS 17+; on iOS 16 the widget paints its own.
    @ViewBuilder
    func widgetBackground(_ color: Color) -> some View {
        if #available(iOS 17.0, *) {
            containerBackground(color, for: .widget)
        } else {
            background(color)
        }
    }
}
