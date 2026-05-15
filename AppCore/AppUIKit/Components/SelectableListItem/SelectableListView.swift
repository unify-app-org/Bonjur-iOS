//
//  SelectableListView.swift
//  AppUIKit
//
//  Created by Cursor on 15.05.26.
//

import SwiftUI

public struct SelectableListView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding private var items: [SelectableListItemView.Model]
    @State private var searchText = ""
    
    private let title: String
    private let subtitle: String
    private let doneTitle: String
    private let minimumSelectionCount: Int
    private let showsBackButton: Bool
    private let showsDoneButton: Bool
    private let onBack: (() -> Void)?
    private let onDone: (() -> Void)?
    
    public init(
        items: Binding<[SelectableListItemView.Model]>,
        title: String,
        subtitle: String,
        doneTitle: String = "Ok",
        minimumSelectionCount: Int = 0,
        showsBackButton: Bool = true,
        showsDoneButton: Bool = true,
        onBack: (() -> Void)? = nil,
        onDone: (() -> Void)? = nil
    ) {
        self._items = items
        self.title = title
        self.subtitle = subtitle
        self.doneTitle = doneTitle
        self.minimumSelectionCount = minimumSelectionCount
        self.showsBackButton = showsBackButton
        self.showsDoneButton = showsDoneButton
        self.onBack = onBack
        self.onDone = onDone
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if showsBackButton {
                backButton
            }
            
            topView
            SearchView(text: $searchText)
            list
            
            if showsDoneButton {
                doneButton
            }
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
    
    private var list: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 16) {
                ForEach(filteredItems, id: \.uuid) { item in
                    SelectableListItemView(model: item)
                        .onTapGesture {
                            toggleItem(with: item.id)
                        }
                }
            }
        }
        .scrollDismissesKeyboard(.interactively)
    }
    
    private var doneButton: some View {
        AppButton(
            title: doneTitle,
            model: .init(contentSize: .fill)
        ) {
            dismissOrPerform(onDone)
        }
        .disabled(selectedCount < minimumSelectionCount)
    }
    
    private var filteredItems: [SelectableListItemView.Model] {
        let searchText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !searchText.isEmpty else {
            return items
        }
        
        return items.filter {
            $0.title.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    private var selectedCount: Int {
        items.filter(\.selected).count
    }
    
    private func toggleItem(with id: Int) {
        items = items.map { item in
            var updatedItem = item
            if item.id == id {
                updatedItem.selected.toggle()
            }
            return updatedItem
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
