//
//  ClubOptionsSheet.swift
//  AppFeature
//
//  Club 3-dot options sheet: Report club / Exit club / Share.
//  Per-module sheet (the activity context menu is not shared across modules).
//  Pure UI — visibility is decided from `viewerRole`, exit orchestration
//  (confirm + owner-transfer gate) lives in `ClubDetailsViewModel`; this view
//  only renders rows and delegates through the input callbacks.
//

import SwiftUI
import AppUIKit
import AppPresentationModel

/// Token that drives the item-based `appSheet` presentation. A fresh value each
/// tap re-presents the sheet; lets the content own its detents.
struct ClubOptionsToken: Identifiable {
    let id = UUID()
}

struct ClubOptionsSheetInput {
    let viewerRole: AppPresentationModel.UserActivityRole
    /// Dismisses the sheet then kicks off the exit flow in the view model.
    let onExit: () -> Void
    /// Stub until the report API ships. Returns `true` on "success".
    let onReport: (AppPresentationModel.ActivityReportReason) async -> Bool
}

struct ClubOptionsSheet: View {

    let input: ClubOptionsSheetInput

    private enum Screen {
        case menu
        case report
    }

    @Environment(\.dismiss) private var dismiss
    @State private var screen: Screen = .menu
    @State private var contentHeight: CGFloat = 200

    /// Exit shows for joined members; Report shows for everyone but the
    /// creator/owner (you can't report your own club).
    private var showExit: Bool { input.viewerRole.isJoinedRole }
    private var showReport: Bool {
        AppPresentationModel.MemberOptionsPolicy.canReportActivity(viewer: input.viewerRole)
    }

    var body: some View {
        content
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.Palette.white)
            .presentationDetents(detents)
            .presentationDragIndicator(.visible)
            .activitySheetWhiteBackground()
            .animation(.easeInOut(duration: 0.22), value: contentHeight)
            .animation(.easeInOut(duration: 0.22), value: screen)
    }

    private var detents: Set<PresentationDetent> {
        switch screen {
        case .report:
            return [.large]
        case .menu:
            return [.height(contentHeight)]
        }
    }

    @ViewBuilder
    private var content: some View {
        switch screen {
        case .menu:
            menu.measureSheetHeight { contentHeight = $0 }
        case .report:
            ActivityReportScreen(
                onBack: { screen = .menu },
                onReport: input.onReport,
                onDone: { dismiss() }
            )
        }
    }

    private var menu: some View {
        VStack(spacing: 0) {
            if showReport {
                ClubOptionRow(
                    systemIcon: "exclamationmark.circle",
                    title: "Report club",
                    tint: Color.Palette.destructiveRed
                ) { screen = .report }
                rowDivider
            }

            if showExit {
                ClubOptionRow(
                    systemIcon: "rectangle.portrait.and.arrow.right",
                    title: "Exit club",
                    tint: Color.Palette.destructiveRed
                ) {
                    dismiss()
                    input.onExit()
                }
                rowDivider
            }

            ClubOptionRow(
                systemIcon: "square.and.arrow.up",
                title: "Share",
                tint: Color.Palette.graySecondary,
                trailing: "Coming soon",
                isDisabled: true
            ) {}
        }
        .padding(.horizontal, 20)
        .padding(.vertical)
    }

    private var rowDivider: some View {
        Divider()
            .overlay(Color.Palette.grayTeritary.opacity(0.6))
            .padding(.leading, 60)
    }
}

// MARK: - Menu row

private struct ClubOptionRow: View {
    let systemIcon: String
    let title: String
    let tint: Color
    var trailing: String? = nil
    var isDisabled: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(tint.opacity(0.10))
                        .frame(width: 40, height: 40)
                    Image(systemName: systemIcon)
                        .font(.system(size: 18, weight: .regular))
                        .foregroundStyle(tint)
                }

                Text(title)
                    .font(Font.Typography.BodyTextMd.medium)
                    .foregroundStyle(tint)

                Spacer(minLength: 0)

                if let trailing {
                    Text(trailing)
                        .font(Font.Typography.TextMd.regular)
                        .foregroundStyle(Color.Palette.graySecondary)
                }
            }
            .padding(.vertical, 16)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .disabled(isDisabled)
    }
}
