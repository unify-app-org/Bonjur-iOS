//
//  LanguageSelectionView.swift
//  ProfileImpl
//
//  Language picker sheet: lists the supported app languages and switches live.
//

import SwiftUI
import AppFoundation
import AppUIKit

struct LanguageSelectionView: View {

    struct Language: Identifiable {
        let code: String
        let flag: String
        let nameKey: String
        var id: String { code }
    }

    private static let languages: [Language] = [
        .init(code: "en", flag: "🇬🇧", nameKey: "language_english"),
        .init(code: "az", flag: "🇦🇿", nameKey: "language_azerbaijan"),
        .init(code: "ru", flag: "🇷🇺", nameKey: "language_russian")
    ]

    private let localization: AppLocalizationProtocol = resolve()
    let onSelect: (String) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("language_title".localized)
                .font(Font.Typography.TitleSm.semiBold)
                .foregroundStyle(Color.Palette.black)
                .padding(.horizontal, 20)
                .padding(.top, 24)
                .padding(.bottom, 16)

            ForEach(Self.languages) { language in
                Button {
                    onSelect(language.code)
                } label: {
                    row(language)
                }
                .buttonStyle(.plain)

                if language.id != Self.languages.last?.id {
                    Divider()
                        .padding(.leading, 20)
                }
            }

            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.Palette.white)
        .localized()
    }

    private func row(_ language: LanguageSelectionView.Language) -> some View {
        HStack(spacing: 16) {
            Text(language.flag)
                .font(.system(size: 32))

            Text(language.nameKey.localized)
                .font(Font.Typography.TextL.regular)
                .foregroundStyle(Color.Palette.black)

            Spacer()

            Image(
                systemName: isSelected(language)
                    ? "largecircle.fill.circle"
                    : "circle"
            )
            .foregroundStyle(
                isSelected(language) ? Color.Palette.black : Color.Palette.grayPrimary
            )
            .font(.system(size: 22))
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .contentShape(Rectangle())
    }

    private func isSelected(_ language: LanguageSelectionView.Language) -> Bool {
        localization.currentLanguage.lowercased() == language.code
    }
}
