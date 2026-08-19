//
//  LanguageSelectionView.swift
//  AppUIKit
//
//  Shared language picker: lists the supported app languages and reports the
//  chosen code back to the caller, which performs the actual switch.
//  Used by Profile settings and by the auth onboarding flow.
//

import SwiftUI
import AppLocalization

public struct LanguageSelectionView: View {

    public struct Language: Identifiable {
        public let code: String
        public let flag: String
        public let nameKey: String
        public var id: String { code }

        public init(code: String, flag: String, nameKey: String) {
            self.code = code
            self.flag = flag
            self.nameKey = nameKey
        }
    }

    /// Supported app languages, in display order.
    public static let languages: [Language] = [
        .init(code: "en", flag: "🇬🇧", nameKey: "language_english"),
        .init(code: "az", flag: "🇦🇿", nameKey: "language_azerbaijan"),
        .init(code: "ru", flag: "🇷🇺", nameKey: "language_russian")
    ]

    /// Flag of the language currently in use, for compact entry points.
    public static func flag(for code: String) -> String {
        languages.first { $0.code == code.lowercased() }?.flag
            ?? languages[0].flag
    }

    @ObservedObject private var languageManager = LanguageManager.shared
    private let onSelect: (String) -> Void

    public init(onSelect: @escaping (String) -> Void) {
        self.onSelect = onSelect
    }

    public var body: some View {
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

    private func row(_ language: Language) -> some View {
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

    private func isSelected(_ language: Language) -> Bool {
        languageManager.languageCode == language.code
    }
}
