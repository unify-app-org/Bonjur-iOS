//
//  RadioSelectItemView.swift
//  AppFoundation
//
//  Created by Huseyn Hasanov on 11.05.26.
//

import SwiftUI
import AppPresentationModel

public struct RadioSelectItemView: View {
    private let title: String
    private let isSelected: Bool
    private let id: String
    private let onClick: (String) -> Void
    
    public init(
        id: String,
        title: String,
        isSelected: Bool = false,
        onClick: @escaping (String) -> Void
    ) {
        self.id = id
        self.title = title
        self.onClick = onClick
        self.isSelected = isSelected
    }
    
    public var body: some View {
        Button {
            onClick(id)
        } label: {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .stroke(isSelected ? Color.Palette.black : Color.Palette.graySecondary, lineWidth: 1)
                        .frame(width: 24, height: 24)
                    
                    if isSelected {
                        Circle()
                            .fill(Color.Palette.black)
                            .frame(width: 12, height: 12)
                    }
                }
                
                Text(title)
                    .font(Font.Typography.BodyTextMd.regular)
                    .foregroundStyle(isSelected ? Color.Palette.blackHigh : Color.Palette.grayPrimary)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(Color.clear)
            .clipShape(Capsule())
            .overlay(
                Capsule().stroke(
                    isSelected ? Color.Palette.black : Color.Palette.graySecondary,
                    lineWidth: isSelected ? 1 : 0.5
                )
            )
        }
        .buttonStyle(.plain)
    }
}
