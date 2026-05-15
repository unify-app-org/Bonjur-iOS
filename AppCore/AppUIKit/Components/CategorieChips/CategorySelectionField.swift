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
        SelectionChipsField(
            title: title,
            addTitle: addTitle,
            items: categories.map {
                SelectionFieldItem(
                    id: $0.id,
                    title: $0.title
                )
            },
            onAdd: onAdd,
            onRemove: onRemove
        )
    }
}
