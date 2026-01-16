//
//  FilterViewModel.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 12.01.26.
//

import Combine

public final class FilterViewModel: ObservableObject {
    // MARK: - Properties
    
    @Published var model: [FilterView.Model]
    @Published var filterModel: [FilterView.Model] = []
    @Published var selectedItem: FilterView.Model?
    
    private let onItemsSelected: ([FilterView.Items]) -> Void
    
    // MARK: - Initialization
    
    public init(
        model: [FilterView.Model],
        selectedItems: @escaping ([FilterView.Items]) -> Void
    ) {
        self.model = model.map { section in
            var updated = section
            updated.items = section.items.sorted {
                $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending
            }
            return updated
        }
        self.onItemsSelected = selectedItems
    }
    
    // MARK: - Public Methods
    
    func fetchFilterScreenData() {
        filterModel = model
    }
    
    func selectItem(_ item: FilterView.Model?) {
        selectedItem = selectedItem?.id == item?.id ? nil : item
    }
    
    func isSelected(_ item: FilterView.Model) -> Bool {
        selectedItem?.id == item.id
    }
    
    func hasSelectedSubItems(_ item: FilterView.Model) -> Bool {
        item.items.contains(where: \.selected)
    }
    
    func getSelectedCount() -> Int {
        model.count { $0.items.contains(where: \.selected) }
    }
    
    // MARK: - Sub-item Selection
    
    func toggleSubItem(_ item: FilterView.Items) {
        selectedItem?.items = selectedItem?.items.map { subItem in
            var updated = subItem
            if updated.id == item.id {
                updated.selected.toggle()
            }
            return updated
        } ?? []
    }
    
    func toggleSubItemInFilterScreen(_ item: FilterView.Items) {
        filterModel = filterModel.map { section in
            updateSection(section, togglingItem: item)
        }
    }
    
    // MARK: - Confirmation Actions
    
    func confirmSelection() {
        guard let selectedItem else { return }
        
        model = model.map { section in
            var updated = section
            if section.id == selectedItem.id {
                updated.items = reorderSelectedFirst(selectedItem.items)
            }
            return updated
        }
        
        notifySelectedItems()
        self.selectedItem = nil
    }
    
    func confirmFilterScreen() {
        model = filterModel.map { section in
            var updated = section
            updated.items = reorderSelectedFirst(section.items)
            return updated
        }
        
        notifySelectedItems()
    }
    
    // MARK: - Removal Actions
    
    func removeSelection() {
        guard let selectedItem else { return }
        
        model = model.map { section in
            var updated = section
            if section.id == selectedItem.id {
                updated.items = sortAlphabetically(
                    section.items.map { subItem in
                        var updatedSubItem = subItem
                        updatedSubItem.selected = false
                        return updatedSubItem
                    }
                )
            }
            return updated
        }
        
        notifySelectedItems()
        self.selectedItem = nil
    }
    
    func removeAllFilters() {
        filterModel = filterModel.map { section in
            var updated = section
            updated.items = sortAlphabetically(
                section.items.map { subItem in
                    var updatedSubItem = subItem
                    updatedSubItem.selected = false
                    return updatedSubItem
                }
            )
            return updated
        }
        
        model = filterModel
        notifySelectedItems()
    }
    
    // MARK: - Private Helpers
    
    private func updateSection(
        _ section: FilterView.Model,
        togglingItem item: FilterView.Items
    ) -> FilterView.Model {
        var updated = section
        updated.items = section.items.map { subItem in
            var updatedSubItem = subItem
            if subItem.id == item.id {
                updatedSubItem.selected.toggle()
            }
            return updatedSubItem
        }
        return updated
    }
    
    private func deselectAllItems(in section: FilterView.Model) -> FilterView.Model {
        var updated = section
        updated.items = section.items.map { subItem in
            var updatedSubItem = subItem
            updatedSubItem.selected = false
            return updatedSubItem
        }
        return updated
    }
    
    private func notifySelectedItems() {
        let allSelectedItems = model.flatMap { $0.items.filter(\.selected) }
        onItemsSelected(allSelectedItems)
    }
    
    private func reorderSelectedFirst(
        _ items: [FilterView.Items]
    ) -> [FilterView.Items] {
        let selected = items.filter { $0.selected }
        let unselected = items.filter { !$0.selected }
        return selected + unselected
    }
    
    private func sortAlphabetically(
        _ items: [FilterView.Items]
    ) -> [FilterView.Items] {
        items.sorted {
            $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending
        }
    }
}
