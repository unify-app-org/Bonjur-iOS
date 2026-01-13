//
//  FilterViewModel.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 12.01.26.
//

import Combine

final class FilterViewModel: ObservableObject {
    @Published var model: [FilterView.Model]
    @Published var selectedItem: FilterView.Model?
    @Published var selectedCount: Int = 0
    
    init(model: [FilterView.Model]) {
        self.model = model
    }
    
    func selectedSubItem(_ item: FilterView.Items) {
        selectedItem?.items = selectedItem?.items.map { subItem in
            var updatedSubItem = subItem
            if updatedSubItem.id == item.id {
                updatedSubItem.selected.toggle()
            }
            return updatedSubItem
        } ?? []
    }
    
    func confirmButtonTapped() {
        model = model.map { items in
            var updated = items
            if let selectedItem {
                if items.id == selectedItem.id {
                    updated.items = selectedItem.items
                }
            }
            return updated
        }
        selectedItem = nil
    }
    
    func removeTapped() {
        model = model.map { items in
            var updated = items
            updated.items = items.items.map { subItem in
                var updateSubItem = subItem
                if let selectedItem, items.id == selectedItem.id {
                    updateSubItem.selected = false
                }
                return updateSubItem
            }
            return updated
        }
        selectedItem = nil
    }
    
    func selectItem(item: FilterView.Model?) {
        selectedItem = selectedItem?.id == item?.id ? nil : item
    }
    
    func selectedItem(_ item: FilterView.Model) -> Bool {
        selectedItem?.id == item.id
    }
    
    func hasSelectedSubItem(_ item: FilterView.Model) -> Bool {
        return item.items.contains(where: { $0.selected } )
    }
    
    func getSectedCount() -> Int {
        return model.count { item in
            item.items.contains(where: { $0.selected } )
        }
    }
}
