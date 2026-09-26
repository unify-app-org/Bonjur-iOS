//
//  HelpCenterView.swift
//  ProfileImpl
//
//  Settings → Help center sheet: how to reach support.
//

import SwiftUI
import AppFoundation
import AppUIKit

struct HelpCenterView: View {
    let onEmailTap: () -> Void
    let onCopyTap: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("settings_help_center".localized)
                .font(Font.Typography.TitleSm.semiBold)
                .foregroundStyle(Color.Palette.black)
                .padding(.top, 24)
                .padding(.bottom, 8)

            Text("help_center_description".localized)
                .font(Font.Typography.BodyTextSm.regular)
                .foregroundStyle(Color.Palette.blackMedium)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, 20)

            emailRow

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.Palette.white)
        .localized()
    }

    private var emailRow: some View {
        HStack(spacing: 16) {
            Button(action: onEmailTap) {
                HStack(spacing: 16) {
                    Image(systemName: "envelope")
                        .font(.system(size: 18))
                        .foregroundStyle(Color.Palette.black)
                        .frame(width: 40, height: 40)
                        .background(Color.Palette.grayQuaternary)
                        .clipShape(RoundedRectangle(cornerRadius: 12))

                    VStack(alignment: .leading, spacing: 2) {
                        Text("help_center_email_label".localized)
                            .font(Font.Typography.TextMd.medium)
                            .foregroundStyle(Color.Palette.blackMedium)
                        Text(SupportContact.email)
                            .font(Font.Typography.BodyTextMd.semiBold)
                            .foregroundStyle(Color.Palette.black)
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                    }

                    Spacer(minLength: 0)
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            Button(action: onCopyTap) {
                Image(systemName: "doc.on.doc")
                    .font(.system(size: 16))
                    .foregroundStyle(Color.Palette.blackMedium)
                    .frame(width: 40, height: 40)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("help_center_copy".localized)
        }
        .padding(12)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.Palette.grayQuaternary, lineWidth: 1)
        )
    }
}
