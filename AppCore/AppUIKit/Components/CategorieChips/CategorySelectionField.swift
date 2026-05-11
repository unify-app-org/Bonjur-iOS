//
//  CategorySelectionField.swift
//  AppUIKit
//
//  Created by Huseyn Hasanov on 11.05.26.
//

import SwiftUI

public struct CategorySelectionField: View {
    private let title: String
    private let addTitle: String
    private let categories: [CategoriesChipsView.Model]
    private let onAdd: () -> Void
    private let onRemove: (Int) -> Void
    
    public init(
        title: String = "Category",
        addTitle: String = "Add category",
        categories: [CategoriesChipsView.Model],
        onAdd: @escaping () -> Void,
        onRemove: @escaping (Int) -> Void
    ) {
        self.title = title
        self.addTitle = addTitle
        self.categories = categories
        self.onAdd = onAdd
        self.onRemove = onRemove
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(Font.Typography.HeadingMd.medium)
                .foregroundStyle(Color.Palette.black)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            if !categories.isEmpty {
                FlowLayout(spacing: 12, items: categories) { category in
                    selectedChip(category)
                }
            }
            
            addButton
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.bottom, 2)
    }
    
    private func selectedChip(_ category: CategoriesChipsView.Model) -> some View {
        HStack(spacing: 8) {
            Text(category.title)
                .font(Font.Typography.BodyTextSm.regular)
                .foregroundStyle(Color.Palette.blackHigh)
            
            Button {
                onRemove(category.id)
            } label: {
                Image(uiImage: UIImage.Icons.xmark)
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 12, height: 12)
                    .foregroundStyle(Color.Palette.blackHigh)
                .padding(4)
            }
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 10)
        .background(Color.Palette.greenLight)
        .clipShape(Capsule())
        .overlay(
            Capsule()
                .stroke(Color.Palette.green900, lineWidth: 0.5)
        )
        .fixedSize()
    }
    
    private var addButton: some View {
        Button(action: onAdd) {
            HStack {
                Text(addTitle)
                    .font(Font.Typography.BodyTextMd.regular)
                    .foregroundStyle(Color.Palette.blackHigh)
                
                Spacer()
                
                Image(uiImage: UIImage.Icons.plus)
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
        .buttonStyle(ScaleOpacityButtonStyle())
    }
}
