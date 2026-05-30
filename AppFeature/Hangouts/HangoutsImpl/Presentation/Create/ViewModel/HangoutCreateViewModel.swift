//
//  HangoutCreateViewModel.swift
//  AppFeature
//
//  Created by Codex on 30.05.26.
//

import AppFoundation
import AppNetwork
import AppUIKit
import Foundation

final class HangoutCreateViewModel: UIFeatureViewModel<HangoutCreateFeature> {
    
    struct Dependencies {
        let useCase: HangoutsUseCase
    }
    
    private let router: HangoutCreateRouterProtocol
    private let inputData: HangoutCreateInputData
    private let dependencies: HangoutCreateViewModel.Dependencies
    private var didApplyPrefillData = false
    
    init(
        state: HangoutCreateFeature.State,
        router: HangoutCreateRouterProtocol,
        inputData: HangoutCreateInputData,
        dependencies: HangoutCreateViewModel.Dependencies
    ) {
        self.router = router
        self.inputData = inputData
        self.dependencies = dependencies
        super.init(initialState: state)
        
        if inputData.id != nil {
            state.disabledName = true
        }
    }
    
    override func handle(action: HangoutCreateFeature.Action) {
        switch action {
        case .fetchData:
            fetchData()
        case .backTapped:
            Task {
                await router.navigate(to: .backTapped)
            }
        case .addCategoryTapped:
            state.showCategoryPicker = true
        case .removeCategory(let id):
            toggleCategory(with: id, selected: false)
        case .dismissCategoryPicker:
            state.showCategoryPicker = false
        case .categoryPickerDone:
            state.showCategoryPicker = false
        case .continueTapped:
            continueTapped()
        }
    }
    
    private func fetchData() {
        Task {
            await fetchCategories()
            await applyPrefillData()
        }
    }
    
    private func fetchCategories() async {
        do {
            state.categorySections = try await dependencies.useCase.getCategories()
        } catch {
            state.categorySections = []
        }
    }
    
    @MainActor
    private func applyPrefillData() {
        guard !didApplyPrefillData,
              let prefillData = inputData.prefillData else {
            return
        }
        
        didApplyPrefillData = true
        state.visibility = prefillData.visibility
        state.name = prefillData.name
        state.ownerContact = prefillData.ownerContact
    
        state.capacity = prefillData.capacity
        state.links = prefillData.links.map(\.appLinkItem)
        state.rules = prefillData.rules
        state.location = prefillData.location
        state.about = prefillData.about
        if let hangoutDate = prefillData.hangoutDate {
            state.hangoutDate = hangoutDate
        }
      
        selectPrefilledCategories(prefillData.categories)
    }
    
    private func selectPrefilledCategories(_ categories: [HangoutsCreate.TagItem]) {
        let selectedIds = Set(categories.map(\.id))
        state.categorySections = state.categorySections.map { section in
            var updatedSection = section
            updatedSection.categories = section.categories.map { category in
                var updatedCategory = category
                updatedCategory.selected = selectedIds.contains(category.id)
                return updatedCategory
            }
            return updatedSection
        }
    }
    
    private func toggleCategory(with id: Int, selected: Bool) {
        state.categorySections = state.categorySections.map { section in
            var updatedSection = section
            updatedSection.categories = section.categories.map { category in
                var updatedCategory = category
                if category.id == id {
                    updatedCategory.selected = selected
                }
                return updatedCategory
            }
            return updatedSection
        }
    }
    
    private func continueTapped() {
        Task {
            if let id = inputData.id {
                await editHangout(id: id)
            } else {
                await createHangout()
            }
        }
    }
    
    private func createHangout() async {
        postEffect(.loading(true))
        defer {
            postEffect(.loading(false))
        }
        
        do {
            try await dependencies.useCase.createHangout(
                request: buildRequest()
            )
            await router.navigate(to: .backTapped)
        } catch {
            postEffect(.error(error as? APIError))
        }
    }
    
    private func editHangout(id: String) async {
        postEffect(.loading(true))
        defer {
            postEffect(.loading(false))
        }
        
        do {
            try await dependencies.useCase.editHangout(
                id: id,
                request: buildRequest()
            )
            await router.navigate(to: .backTapped)
        } catch {
            postEffect(.error(error as? APIError))
        }
    }
    
    private func buildRequest() -> HangoutsDTOModel.Request {
        HangoutsDTOModel.Request(
            visibility: state.visibility,
            name: state.name,
            ownerContact: state.ownerContact,
            categoriesId: state.selectedCategories.map(\.id),
            capacity: Int(state.capacity) ?? 0,
            links: state.links.map(\.hangoutLink),
            rules: state.rules,
            location: state.location,
            about: state.about,
            hangoutDate: isoString(from: state.hangoutDate)
        )
    }
    
    private func isoString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return formatter.string(from: date)
    }
}

private extension HangoutsCreate.LinkItem {
    var appLinkItem: AppLinkItem {
        AppLinkItem(
            id: id,
            type: type,
            name: name,
            url: url
        )
    }
}

private extension AppLinkItem {
    var hangoutLink: HangoutsDTOModel.Link {
        HangoutsDTOModel.Link(
            type: type,
            name: name,
            url: url
        )
    }
}
