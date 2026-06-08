//
//  EventCreateViewModel.swift
//  EventsImpl
//
//  Created by Huseyn Hasanov on 21.02.26.
//

import AppFoundation
import AppUIKit

final class EventCreateViewModel: UIFeatureViewModel<EventCreateFeature> {

    struct Dependencies {
        let useCase: EventsUseCase
    }

    private let router: EventCreateRouterProtocol
    private let inputData: EventCreateInputData
    private let dependencies: EventCreateViewModel.Dependencies
    private var didApplyPrefillData = false

    init(
        state: EventCreateFeature.State,
        router: EventCreateRouterProtocol,
        inputData: EventCreateInputData,
        dependencies: EventCreateViewModel.Dependencies
    ) {
        self.router = router
        self.inputData = inputData
        self.dependencies = dependencies
        super.init(initialState: state)

        if inputData.eventId != nil {
            self.state.isEdit = true
        }
    }

    override func handle(action: EventCreateFeature.Action) {
        switch action {
        case .fetchData:
            fetchData()
        case .backTapped:
            Task { await router.navigate(to: .backTapped) }
        case .continueTapped:
            continueTapped()
        case .selectClubTapped:
            state.showClubPicker = true
        case .dismissClubPicker:
            state.showClubPicker = false
        case .selectClub(let clubId):
            state.selectedClubId = clubId
            state.showClubPicker = false
        case .addCategoryTapped:
            state.showCategoryPicker = true
        case .removeCategory(let id):
            setCategory(id: id, selected: false)
            syncSelectedCategories()
        case .dismissCategoryPicker:
            syncSelectedCategories()
            state.showCategoryPicker = false
        case .categoryPickerDone:
            syncSelectedCategories()
            state.showCategoryPicker = false
        }
    }

    private func fetchData() {
        Task {
            await fetchClubs()
            await fetchCategories()
            applyPrefillData()
        }
    }

    private func applyPrefillData() {
        guard !didApplyPrefillData,
              let prefill = inputData.prefillData else {
            return
        }
        didApplyPrefillData = true
        state.selectedClubId = prefill.selectedClubId
        state.values.merge(prefill.values) { _, new in new }
        selectPrefilledCategories(state.values.tags(.category))
    }

    private func selectPrefilledCategories(_ categories: [EventsCreate.TagItem]) {
        let selectedIds = Set(categories.map(\.id))
        state.categorySections = state.categorySections.map { section in
            var section = section
            section.categories = section.categories.map { category in
                var category = category
                category.selected = selectedIds.contains(category.id)
                return category
            }
            return section
        }
    }

    private func fetchClubs() async {
        do {
            state.clubs = try await dependencies.useCase.fetchClubsForEvents()
        } catch {
            state.clubs = []
        }
    }

    private func fetchCategories() async {
        do {
            state.categorySections = try await dependencies.useCase.getCategories()
        } catch {
            state.categorySections = []
        }
    }

    // MARK: - Categories

    private func setCategory(id: Int, selected: Bool) {
        state.categorySections = state.categorySections.map { section in
            var updated = section
            updated.categories = section.categories.map { category in
                var category = category
                if category.id == id { category.selected = selected }
                return category
            }
            return updated
        }
    }

    private func syncSelectedCategories() {
        state.values[.category] = .tags(
            state.selectedCategories.map { EventsCreate.TagItem(id: $0.id, label: $0.title) }
        )
    }

    // MARK: - Submit

    private func continueTapped() {
        guard let request = buildRequest() else { return }
        Task {
            postEffect(.loading(true))
            defer { postEffect(.loading(false)) }
            do {
                try await dependencies.useCase.createEvent(request: request)
                await router.navigate(to: .backTapped)
            } catch {
            }
        }
    }

    private func buildRequest() -> EventsCreate.Request? {
        guard let clubId = state.selectedClubId else { return nil }
        let values = state.values
        let links: [EventsCreate.Request.Link] = values.links(.links).map {
            .init(type: $0.type, name: $0.name, url: $0.url)
        }
        return EventsCreate.Request(
            clubId: clubId,
            name: values.text(.eventName),
            about: values.text(.about),
            location: values.text(.location),
            ownerContact: values.text(.ownerContact),
            capacity: Int(values.text(.capacity)),
            rules: values.text(.rules).isEmpty ? nil : values.text(.rules),
            visibility: values.radio(.visibility) == .public ? "PUBLIC" : "PRIVATE",
            eventDate: values.date(.eventDate),
            reminder: values.reminder(.reminder).rawValue,
            categoryIds: values.tags(.category).map(\.id),
            links: links
        )
    }
}
