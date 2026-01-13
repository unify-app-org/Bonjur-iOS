//
//  FilterViewModel.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 12.01.26.
//

import Combine

final class FilterViewModel: ObservableObject {
    // MARK: - Properties
    
    @Published var model: [FilterView.Model]
    @Published var filterModel: [FilterView.Model] = []
    @Published var selectedItem: FilterView.Model?
    
    private let onItemsSelected: ([FilterView.Items]) -> Void
    
    // MARK: - Initialization
    
    init(
        model: [FilterView.Model],
        selectedItems: @escaping ([FilterView.Items]) -> Void
    ) {
        self.model = model
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
                updated.items = selectedItem.items
            }
            return updated
        }
        
        notifySelectedItems()
        self.selectedItem = nil
    }
    
    func confirmFilterScreen() {
        model = filterModel
        notifySelectedItems()
    }
    
    // MARK: - Removal Actions
    
    func removeSelection() {
        guard let selectedItem else { return }
        
        model = model.map { section in
            var updated = section
            if section.id == selectedItem.id {
                updated.items = section.items.map { subItem in
                    var updatedSubItem = subItem
                    updatedSubItem.selected = false
                    return updatedSubItem
                }
            }
            return updated
        }
        
        notifySelectedItems()
        self.selectedItem = nil
    }
    
    func removeAllFilters() {
        filterModel = filterModel.map { section in
            deselectAllItems(in: section)
        }
        
        model = filterModel
        notifySelectedItems()
    }
    
    // MARK: - Private Helpers
    
    private func updateSection(_ section: FilterView.Model, togglingItem item: FilterView.Items) -> FilterView.Model {
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
}
