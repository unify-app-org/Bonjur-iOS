//
//  SelectCategoryView.swift
//  AppUIKit
//
//  Created by Huseyn Hasanov on 11.05.26.
//

import SwiftUI

public struct SelectCategoryView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding private var sections: [Section]
    @State private var searchText = ""
    
    private let title: String
    private let subtitle: String
    private let minimumSelectionCount: Int
    private let onBack: (() -> Void)?
    private let onDone: (() -> Void)?
    
    public init(
        sections: Binding<[Section]>,
        title: String = "Select category",
        subtitle: String = "You must be choose at least 2 category",
        minimumSelectionCount: Int = 0,
        onBack: (() -> Void)? = nil,
        onDone: (() -> Void)? = nil
    ) {
        self._sections = sections
        self.title = title
        self.subtitle = subtitle
        self.minimumSelectionCount = minimumSelectionCount
        self.onBack = onBack
        self.onDone = onDone
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            backButton
            topView
            SearchView(text: $searchText)
            list
            doneButton
        }
        .padding()
        .dismissKeyboardOnTap()
    }
    
    private var backButton: some View {
        HStack {
            Spacer()
            Button {
                dismissOrPerform(onBack)
            } label: {
                Image(uiImage: UIImage.Icons.xmark)
                    .renderingMode(.template)
                    .foregroundStyle(Color.Palette.black)
                    .padding(8)
                    .applyGlassIfAvailable()
            }
            .buttonStyle(ScaleOpacityButtonStyle())
        }
    }
    
    private var topView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(Font.Typography.TitleL.extraBold)
                .foregroundStyle(Color.Palette.black)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(subtitle)
                .font(Font.Typography.BodyTextMd.regular)
                .foregroundStyle(Color.Palette.grayPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    @ViewBuilder
    private var list: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(alignment: .leading, spacing: 16) {
                ForEach(filteredSections) { section in
                    Text(section.title)
                        .foregroundStyle(Color.Palette.blackHigh)
                        .font(Font.Typography.BodyTextMd.semiBold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    FlowLayout(spacing: 12, items: section.categories) { item in
                        CategoriesChipsView(model: item)
                            .onTapGesture {
                                toggleCategory(with: item.id)
                            }
                    }
                }
            }
        }
        .scrollDismissesKeyboard(.interactively)
    }
    
    private var doneButton: some View {
        AppButton(
            title: "Ok",
            model: .init(contentSize: .fill)
        ) {
            dismissOrPerform(onDone)
        }
        .disabled(selectedCount < minimumSelectionCount)
    }
    
    private var selectedCount: Int {
        sections.flatMap(\.categories).filter(\.selected).count
    }
    
    private var filteredSections: [Section] {
        let searchText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !searchText.isEmpty else {
            return sections
        }
        
        return sections.compactMap { section in
            var updatedSection = section
            updatedSection.categories = section.categories.filter {
                $0.title.localizedCaseInsensitiveContains(searchText)
            }
            return updatedSection.categories.isEmpty ? nil : updatedSection
        }
    }
    
    private func toggleCategory(with id: Int) {
        sections = sections.map { section in
            var updatedSection = section
            updatedSection.categories = section.categories.map { category in
                var updatedCategory = category
                if category.id == id {
                    updatedCategory.selected.toggle()
                }
                return updatedCategory
            }
            return updatedSection
        }
    }
    
    private func dismissOrPerform(_ action: (() -> Void)?) {
        if let action {
            action()
        } else {
            dismiss()
        }
    }
}

public extension SelectCategoryView {
    struct Section: Identifiable, Hashable {
        public let id = UUID()
        public let type: String
        public let title: String
        public var categories: [CategoriesChipsView.Model]
        
        public init(
            type: String,
            title: String,
            categories: [CategoriesChipsView.Model]
        ) {
            self.type = type
            self.title = title
            self.categories = categories
        }
    }
}
