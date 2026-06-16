//
//  CommunityOptionsSheet.swift
//  AppFeature
//
//  Community 3-dot options sheet. Communities only surface Share (coming soon)
//  for now — no exit/report (you don't leave or report the parent community
//  from here). Per-module sheet.
//

import SwiftUI
import AppUIKit

struct CommunityOptionsToken: Identifiable {
    let id = UUID()
}

struct CommunityOptionsSheet: View {

    @State private var contentHeight: CGFloat = 120

    var body: some View {
        menu
            .measureSheetHeight { contentHeight = $0 }
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.Palette.white)
            .presentationDetents([.height(contentHeight)])
            .presentationDragIndicator(.visible)
            .activitySheetWhiteBackground()
            .animation(.easeInOut(duration: 0.22), value: contentHeight)
    }

    private var menu: some View {
        VStack(spacing: 0) {
            CommunityOptionRow(
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
}

private struct CommunityOptionRow: View {
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
