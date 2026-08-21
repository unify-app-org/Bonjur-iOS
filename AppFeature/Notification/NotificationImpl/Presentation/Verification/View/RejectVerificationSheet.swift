//
//  RejectVerificationSheet.swift
//  NotificationImpl
//
//  Confirmation sheet for rejecting a club's verification request. Replaces the
//  old confirm alert: it doubles as the confirmation step and as the input for
//  the optional note (`rejectionReason`) the club's organiser will read.
//

import SwiftUI
import AppFoundation
import AppUIKit

struct RejectVerificationSheet: View {

    let item: VerificationItem
    /// Called with the trimmed note, or `nil` when the field was left blank.
    let onReject: (String?) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var note: String = ""
    /// Intrinsic content height so the sheet fits its content instead of
    /// snapping to `.medium`.
    @State private var contentHeight: CGFloat = 420

    private let noteLimit = 300

    var body: some View {
        content
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.Palette.white)
            .presentationDetents([.height(contentHeight)])
            .presentationDragIndicator(.visible)
            .activitySheetWhiteBackground()
            .animation(.easeInOut(duration: 0.22), value: contentHeight)
    }

    private var content: some View {
        VStack(alignment: .leading, spacing: 16) {
            ActivitySheetHeader(title: "notif_reject_verification".localized) { dismiss() }

            Text(String(format: "notif_reject_note_desc".localized, item.clubName))
                .font(Font.Typography.TextL.regular)
                .foregroundStyle(Color.Palette.graySecondary)
                .fixedSize(horizontal: false, vertical: true)

            TextView(
                text: $note,
                characterLimit: noteLimit,
                model: .init(title: "notif_reject_note_label".localized)
            )
            .frame(height: 150)

            Text("notif_reject_note_hint".localized)
                .font(Font.Typography.TextMd.regular)
                .foregroundStyle(Color.Palette.graySecondary)
                .fixedSize(horizontal: false, vertical: true)

            HStack(spacing: 12) {
                AppButton(
                    title: "common_cancel".localized,
                    model: .init(type: .secondary, contentSize: .fill)
                ) { dismiss() }

                AppButton(
                    title: "notif_reject".localized,
                    model: .init(type: .destructive, style: .hover, contentSize: .fill)
                ) { submit() }
            }
            .padding(.top, 8)
        }
        .padding(20)
        .measureSheetHeight { contentHeight = $0 }
    }

    private func submit() {
        let trimmed = note.trimmingCharacters(in: .whitespacesAndNewlines)
        onReject(trimmed.isEmpty ? nil : trimmed)
        dismiss()
    }
}
