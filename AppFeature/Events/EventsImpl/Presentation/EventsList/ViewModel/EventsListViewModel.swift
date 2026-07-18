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
    private let paginationStep = 10
    private let searchDebounceNanoseconds: UInt64 = 300_000_000
    private var eventsSize = 10
    private var isLoadingMoreEvents = false
    private var hasMoreEvents = true
    private var selectedCategoryIds: [Int] = []
    private var searchTask: Task<Void, Never>?

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
        case .loadMore:
            loadMoreEvents()
        case .searchChanged(let text):
            searchChanged(text)
        case .eventItemTapped(let id):
            Task {
                await router.navigate(to: .showDetails(id: id))
            }
        case .joinEvent(let id):
            Task {
                await joinEvent(id: id)
            }
        case .createTapped:
            Task {
                await router.navigate(to: .createEvent)
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
        eventsSize = paginationStep
        hasMoreEvents = true
        Task {
            await getEventsData()
        }
    }

    private func getEventsData() async {
        do {
            let events = try await dependencies.useCase.fetchEvents(
                categoryIds: selectedCategoryIds,
                keyword: currentKeyword,
                page: 0,
                size: eventsSize
            )
            hasMoreEvents = events.count >= eventsSize
            state.uiModel.events = events
        } catch {
            print(error)
        }
    }

    private func loadMoreEvents() {
        guard !isLoadingMoreEvents, hasMoreEvents else { return }
        isLoadingMoreEvents = true
        let previousSize = eventsSize
        eventsSize += paginationStep

        Task {
            defer {
                isLoadingMoreEvents = false
            }

            do {
                let previousCount = state.uiModel.events.count
                let events = try await dependencies.useCase.fetchEvents(
                    categoryIds: selectedCategoryIds,
                    keyword: currentKeyword,
                    page: 0,
                    size: eventsSize
                )
                hasMoreEvents = events.count > previousCount
                state.uiModel.events = events
            } catch {
                eventsSize = previousSize
                print(error)
            }
        }
    }

    private func searchChanged(_ text: String) {
        state.searchText = text
        eventsSize = paginationStep
        hasMoreEvents = true

        searchTask?.cancel()
        searchTask = Task { [weak self] in
            guard let self else { return }
            try? await Task.sleep(nanoseconds: searchDebounceNanoseconds)
            guard !Task.isCancelled else { return }
            await getEventsData()
        }
    }

    private var currentKeyword: String? {
        let keyword = state.searchText
            .trimmingCharacters(in: .whitespacesAndNewlines)
        return keyword.isEmpty ? nil : keyword
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
