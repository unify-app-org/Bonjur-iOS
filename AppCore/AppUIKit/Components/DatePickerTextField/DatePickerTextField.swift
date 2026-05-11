//
//  DatePickerTextField.swift
//  AppUIKit
//
//  Created by Huseyn Hasanov on 11.05.26.
//

import SwiftUI

public struct DatePickerTextField: View {
    private let title: String
    private let text: String
    private let placeholder: String
    private let onTap: () -> Void
    
    public init(
        title: String = "Birthday",
        text: String,
        placeholder: String = "MM/DD/YYYY",
        onTap: @escaping () -> Void
    ) {
        self.title = title
        self.text = text
        self.placeholder = placeholder
        self.onTap = onTap
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(Font.Typography.HeadingMd.medium)
                .foregroundStyle(Color.Palette.black)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Button(action: onTap) {
                HStack {
                    Text(text.isEmpty ? placeholder : text)
                        .font(Font.Typography.BodyTextMd.regular)
                        .foregroundStyle(text.isEmpty ? Color.Palette.grayPrimary : Color.Palette.blackHigh)
                    
                    Spacer()
                    
                    Image(uiImage: UIImage.Icons.calendar)
                        .renderingMode(.template)
                        .foregroundStyle(Color.Palette.blackHigh)
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
                .background(Color.clear)
                .contentShape(Capsule())
                .clipShape(Capsule())
                .overlay(
                    Capsule().stroke(
                        Color.Palette.graySecondary,
                        lineWidth: 0.5
                    )
                )
            }
            .frame(maxWidth: .infinity)
            .buttonStyle(.plain)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
