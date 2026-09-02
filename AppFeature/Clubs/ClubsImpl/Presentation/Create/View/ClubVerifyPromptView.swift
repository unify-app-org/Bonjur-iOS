//
//  ClubVerifyPromptView.swift
//  AppFeature
//
//  Post-create sheet: a new club is unverified, and verification is the hard
//  gate to creating events in it. Reuses the optimistic request flow until the
//  backend verify-request endpoint lands.
//

import SwiftUI
import AppFoundation
import AppUIKit

struct ClubVerifyPromptView: View {
    let onRequestVerification: () -> Void
    let onLater: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "checkmark.seal.fill")
                .font(.system(size: 40, weight: .semibold))
                .foregroundStyle(Color.Palette.appBlue)
                .padding(.top, 8)

            Text("clubs_created_title".localized)
                .font(Font.Typography.TitleMd.extraBold)
                .multilineTextAlignment(.center)
                .foregroundStyle(Color.Palette.black)

            Text("clubs_verify_prompt_body".localized)
                .font(Font.Typography.BodyTextSm.regular)
                .multilineTextAlignment(.center)
                .foregroundStyle(Color.Palette.blackMedium)
                // Without this the sheet's fixed detent squeezes the copy into two
                // lines and truncates it.
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal, 8)

            VStack(spacing: 8) {
                AppButton(
                    title: "clubs_request_verification".localized,
                    model: .init(type: .primary, contentSize: .fill),
                    action: onRequestVerification
                )
                AppButton(
                    title: "common_later".localized,
                    model: .init(type: .tertiary, contentSize: .fill),
                    action: onLater
                )
            }
            .padding(.top, 4)
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(Color.Palette.white)
    }
}
