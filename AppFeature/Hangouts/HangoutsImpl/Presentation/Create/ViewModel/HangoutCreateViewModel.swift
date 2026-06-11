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
            state.disabledFieldIDs = [.hangoutName]
            state.isEdit = true
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
            syncSelectedCategories()
        case .dismissCategoryPicker:
            syncSelectedCategories()
            state.showCategoryPicker = false
        case .categoryPickerDone:
            syncSelectedCategories()
            state.showCategoryPicker = false
        case .continueTapped:
            continueTapped()
        }
    }

    private func fetchData() {
        Task {
            await fetchCreate()
            await fetchCategories()
            await applyPrefillData()
        }
    }

    private func fetchCreate() async {
        do {
            state.hangoutsCreateSchema = try await dependencies.useCase.fetchCreateFields()
        } catch { }
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
        state.values.merge(prefillData.values) { _, new in new }
        selectPrefilledCategories(prefillData.values.tags(.category))
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

    private func syncSelectedCategories() {
        state.values[.category] = .tags(
            state.selectedCategories.map {
                HangoutsCreate.TagItem(id: $0.id, label: $0.title)
            }
        )
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
            AppSnackBar.show(
                title: "Hangout created successfully",
                subtitle: state.values.text(.hangoutName),
                style: .success
            )
            await router.navigate(to: .backTapped)
        } catch {
            postEffect(.error(error))
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
            AppSnackBar.show(
                title: "Hangout updated successfully",
                subtitle: state.values.text(.hangoutName),
                style: .success
            )
            await router.navigate(to: .backTapped)
        } catch {
            postEffect(.error(error))
        }
    }

    private func buildRequest() -> HangoutsDTOModel.Request {
        HangoutsDTOModel.Request(
            visibility: state.values.radio(.visibility),
            name: state.values.text(.hangoutName),
            ownerContact: state.values.text(.ownerContact),
            categoriesId: state.values.tags(.category).map(\.id),
            capacity: Int(state.values.text(.capacity)) ?? 0,
            links: state.values.links(.links).map(\.hangoutLink),
            rules: state.values.text(.rules),
            location: state.values.text(.location),
            about: state.values.text(.about),
            hangoutDate: isoString(from: state.values.date(.hangoutDate))
        )
    }

    private func isoString(from date: Date) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.formatOptions = [
            .withInternetDateTime,
            .withFractionalSeconds
        ]
        return formatter.string(from: date)
    }
}

private extension HangoutsCreate.LinkItem {
    var hangoutLink: HangoutsDTOModel.Link {
        HangoutsDTOModel.Link(
            type: type,
            name: name,
            url: url
        )
    }
}
