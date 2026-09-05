//
//  CategorySelectionField.swift
//  AppUIKit
//
//  Created by Huseyn Hasanov on 11.05.26.
//

import SwiftUI
import AppLocalization

public struct CategorySelectionField: View {
    private let title: String
    private let addTitle: String
    private let isRequired: Bool?
    private let categories: [CategoriesChipsView.Model]
    private let onAdd: () -> Void
    private let onRemove: (Int) -> Void
    
    /// The defaults are resolved at each call site, so they follow a language switch —
    /// the profile edit form relies on them and used to show English "Category" /
    /// "Add category" whatever language the app was in.
    public init(
        title: String = "common_category".localized,
        addTitle: String = "common_add_category".localized,
        isRequired: Bool? = nil,
        categories: [CategoriesChipsView.Model],
        onAdd: @escaping () -> Void,
        onRemove: @escaping (Int) -> Void
    ) {
        self.title = title
        self.addTitle = addTitle
        self.isRequired = isRequired
        self.categories = categories
        self.onAdd = onAdd
        self.onRemove = onRemove
    }
    
    public var body: some View {
        SelectionChipsField(
            title: title,
            addTitle: addTitle,
            isRequired: isRequired,
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
