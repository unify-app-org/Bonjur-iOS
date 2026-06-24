//
//  EventsListViewModel.swift
//  EventsImpl
//
//  Created by Huseyn Hasanov on 22.01.26.
//

import AppUIKit
import AppFoundation
import AppNetwork

final class EventsListViewModel: UIFeatureViewModel<EventsListFeature> {

    struct Dependencies {
        let useCase: EventsUseCase
    }

    private let router: EventsListRouterProtocol
    private let inputData: EventsListInputData
    private let dependencies: EventsListViewModel.Dependencies
    private var selectedCategoryIds: [Int] = []

    init(
        state: EventsListFeature.State,
        router: EventsListRouterProtocol,
        inputData: EventsListInputData,
        dependencies: EventsListViewModel.Dependencies
    ) {
        self.router = router
        self.inputData = inputData
        self.dependencies = dependencies
        super.init(initialState: state)
    }
    
    override func handle(action: EventsListFeature.Action) {
        switch action {
        case .fetchData:
            fetchData()
        case .fetchCategories:
            fetchCategories()
        case .filtersSelected(let items):
            filtersSelected(items)
        case .eventItemTapped(let id):
            Task {
                await router.navigate(to: .showDetails(id: id))
            }
        case .joinEvent(let id):
            Task {
                await joinEvent(id: id)
            }
        }
    }

    private func fetchData() {
        Task {
            await getEventsData()
        }
    }

    private func fetchCategories() {
        Task {
            do {
                let filters = try await dependencies.useCase.getFilterCategories()
                state.uiModel.filters = filters.applyingSelectedItemIds(selectedCategoryIds)
            } catch {
                postEffect(.error(error as! APIError))
            }
        }
    }

    private func filtersSelected(_ items: [FilterView.Items]) {
        selectedCategoryIds = items.map(\.id)
        state.uiModel.filters = state.uiModel.filters.applyingSelectedItemIds(selectedCategoryIds)
        Task {
            await getEventsData()
        }
    }

    private func getEventsData() async {
        do {
            state.uiModel.events = try await dependencies.useCase.fetchEvents(categoryIds: selectedCategoryIds)
        } catch {
            postEffect(.error(error))
        }
    }

    private func joinEvent(id: String) async {
        postEffect(.loading(true))
        defer {
            postEffect(.loading(false))
        }
        do {
            try await dependencies.useCase.joinEvent(eventId: id)
            await getEventsData()
        } catch {
            postEffect(.error(error))
        }
    }
}
