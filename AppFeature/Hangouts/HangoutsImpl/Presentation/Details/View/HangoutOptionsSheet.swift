//
//  HangoutOptionsSheet.swift
//  AppFeature
//
//  Hangout 3-dot options sheet: Report hangout / Exit hangout / Share.
//  Per-module sheet. Exit confirmation lives in `HangoutDetailsViewModel`
//  (hangouts have no owner-transfer gate); this view only renders rows.
//

import SwiftUI
import AppFoundation
import AppUIKit
import AppPresentationModel

struct HangoutOptionsToken: Identifiable {
    let id = UUID()
}

struct HangoutOptionsSheetInput {
    let viewerRole: AppPresentationModel.UserActivityRole
    let onExit: () -> Void
    let onReport: (AppPresentationModel.ActivityReportReason) async -> Bool
}

struct HangoutOptionsSheet: View {

    let input: HangoutOptionsSheetInput

    private enum Screen {
        case menu
        case report
    }

    @Environment(\.dismiss) private var dismiss
    @State private var screen: Screen = .menu
    @State private var contentHeight: CGFloat = 200

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
                HangoutOptionRow(
                    systemIcon: "exclamationmark.circle",
                    title: "hangouts_report".localized,
                    tint: Color.Palette.destructiveRed
                ) { screen = .report }
                rowDivider
            }

            if showExit {
                HangoutOptionRow(
                    systemIcon: "rectangle.portrait.and.arrow.right",
                    title: "hangouts_exit_confirm".localized,
                    tint: Color.Palette.destructiveRed
                ) {
                    dismiss()
                    input.onExit()
                }
                rowDivider
            }

            HangoutOptionRow(
                systemIcon: "square.and.arrow.up",
                title: "common_share".localized,
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

private struct HangoutOptionRow: View {
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
