//
//  AppSelectorField.swift
//  AppUIKit
//
//  Created by Huseyn Hasanov on 11.06.26.
//

import SwiftUI

/// Generic labelled selector field: leading avatar + value + trailing chevron in a
/// filled rounded box. Reusable for any "pick one entity" field (club, community, …).
/// When disabled the box darkens and taps are ignored.
public struct AppSelectorField: View {

    private let title: String
    private let isRequired: Bool
    private let imageURL: URL?
    private let value: String
    private let placeholder: String
    private let isDisabled: Bool
    /// Note under the box, e.g. "you can't move this to another club later". Hidden once
    /// the field is disabled — the warning has served its purpose by then.
    private let hint: String?
    private let onTap: () -> Void

    public init(
        title: String,
        isRequired: Bool = false,
        imageURL: URL? = nil,
        value: String,
        placeholder: String = "Select",
        isDisabled: Bool = false,
        hint: String? = nil,
        onTap: @escaping () -> Void
    ) {
        self.title = title
        self.isRequired = isRequired
        self.imageURL = imageURL
        self.value = value
        self.placeholder = placeholder
        self.isDisabled = isDisabled
        self.hint = hint
        self.onTap = onTap
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            labelView
            Button(action: onTap) { boxView }
                .buttonStyle(.plain)
                .disabled(isDisabled)
            FieldHint(text: hint, isDisabled: isDisabled)
        }
    }

    private var labelView: some View {
        HStack(spacing: 2) {
            Text(title)
                .font(Font.Typography.HeadingMd.medium)
                .foregroundStyle(Color.Palette.blackHigh)
            if isRequired {
                Text("*")
                    .font(Font.Typography.HeadingMd.medium)
                    .foregroundStyle(Color.Palette.green900)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var boxView: some View {
        HStack(spacing: 12) {
            if let imageURL {
                CachedAsyncImage(url: imageURL) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    Circle().fill(Color.Palette.grayTeritary)
                }
                .frame(width: 40, height: 40)
                .clipShape(Circle())
            }

            Text(value.isEmpty ? placeholder : value)
                .font(Font.Typography.BodyTextMd.regular)
                .foregroundStyle(valueColor)
                .lineLimit(1)

            Spacer(minLength: 0)

            Image(uiImage: UIImage.Icons.chevronDown02)
                .renderingMode(.template)
                .foregroundStyle(isDisabled ? Color.Palette.blackMedium : Color.Palette.blackHigh)
        }
        .padding(12)
        .frame(maxWidth: .infinity)
        .background(isDisabled ? Color.Palette.grayTeritary : Color.Palette.grayQuaternary)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var valueColor: Color {
        if value.isEmpty { return Color.Palette.blackMedium }
        return isDisabled ? Color.Palette.blackMedium : Color.Palette.blackHigh
    }
}
