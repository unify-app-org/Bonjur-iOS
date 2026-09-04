//
//  GroupsListViewModel.swift
//  GroupsImpl
//
//  Created by Huseyn Hasanov on 23.01.26.
//

import AppFoundation
import AppNetwork
import Clubs
import Events
import Hangouts

final class GroupsListViewModel: UIFeatureViewModel<GroupsListFeature> {
    
    struct Dependencies {
        let useCase: GroupsUseCase
    }
    
    private let router: GroupsListRouterProtocol
    private let inputData: GroupsListInputData
    private let dependencies: GroupsListViewModel.Dependencies
    private static let pageSize = 10
    private let searchDebounceNanoseconds: UInt64 = 300_000_000
    /// Last page index fetched per tab. Pages are appended; the previous version grew
    /// `size` and refetched page 0 every time, which re-downloaded the whole list on
    /// every scroll and reset the scroll position.
    private var clubsPage = 0
    private var eventsPage = 0
    private var hangoutsPage = 0
    private var isLoadingMoreClubs = false
    private var isLoadingMoreEvents = false
    private var isLoadingMoreHangouts = false
    private var searchTask: Task<Void, Never>?
    
    init(
        state: GroupsListFeature.State,
        router: GroupsListRouterProtocol,
        inputData: GroupsListInputData,
        dependencies: GroupsListViewModel.Dependencies
    ) {
        self.router = router
        self.inputData = inputData
        self.dependencies = dependencies
        super.init(initialState: state)
    }
    
    override func handle(action: GroupsListFeature.Action) {
        switch action {
        case .fetchData:
            fetchData()
        case .loadMoreClubs:
            loadMoreClubs()
        case .loadMoreEvents:
            loadMoreEvents()
        case .loadMoreHangouts:
            loadMoreHangouts()
        case .searchChanged(let text):
            searchChanged(text)
        case .clubItemTapped(let id):
            Task {
                await router.navigate(to: .clubDetail(id: id))
            }
        case .eventItemTapped(let id):
            Task {
                await router.navigate(to: .eventDetail(id: id))
            }
        case .hangoutItemTapped(let id):
            Task {
                await router.navigate(to: .hangoutDetail(id: id))
            }
        case .emptyStateActionTapped(let segment):
            // Clubs/events send the user somewhere to join one; hangouts can be
            // started outright, so that tab opens the create flow.
            let route: GroupsListRoute = switch segment {
            case .clubs: .exploreClubs
            case .events: .exploreEvents
            case .hangouts: .createHangout
            }
            Task { @MainActor in
                router.navigate(to: route)
            }
        }
    }
    
    private func fetchData() {
        Task {
            postEffect(.loading(true))
            await getClubs()
            await getEvents()
            await getHangouts()
            postEffect(.loading(false))
        }
    }
    
    private func getClubs() async {
        do {
            let result = try await dependencies.useCase.fetchClubs(
                query: makeQuery(page: 0)
            )
            clubsPage = result.page
            state.uiModel.clubs = result.items
            state.clubsHasMore = result.hasMore
            state.clubsPagesLoaded += 1
        } catch {
            postError(error)
        }
    }

    private func getEvents() async {
        do {
            let result = try await dependencies.useCase.fetchEvents(
                query: makeQuery(page: 0)
            )
            eventsPage = result.page
            state.uiModel.events = result.items
            state.eventsHasMore = result.hasMore
            state.eventsPagesLoaded += 1
        } catch {
            postError(error)
        }
    }

    private func getHangouts() async {
        do {
            let result = try await dependencies.useCase.fetchHangouts(
                query: makeQuery(page: 0)
            )
            hangoutsPage = result.page
            state.uiModel.hangouts = result.items
            state.hangoutsHasMore = result.hasMore
            state.hangoutsPagesLoaded += 1
        } catch {
            postError(error)
        }
    }
    
    private func loadMoreClubs() {
        guard !isLoadingMoreClubs, state.clubsHasMore else { return }
        isLoadingMoreClubs = true
        let nextPage = clubsPage + 1

        Task {
            defer { isLoadingMoreClubs = false }
            do {
                let result = try await dependencies.useCase.fetchClubs(
                    query: makeQuery(page: nextPage)
                )
                clubsPage = result.page
                state.uiModel.clubs = Self.appending(
                    result.items,
                    to: state.uiModel.clubs,
                    id: \.id
                )
                state.clubsHasMore = result.hasMore
                state.clubsPagesLoaded += 1
            } catch {
                // Stop paging rather than retry-looping the sentinel on every scroll.
                state.clubsHasMore = false
                postError(error)
            }
        }
    }

    private func loadMoreEvents() {
        guard !isLoadingMoreEvents, state.eventsHasMore else { return }
        isLoadingMoreEvents = true
        let nextPage = eventsPage + 1

        Task {
            defer { isLoadingMoreEvents = false }
            do {
                let result = try await dependencies.useCase.fetchEvents(
                    query: makeQuery(page: nextPage)
                )
                eventsPage = result.page
                state.uiModel.events = Self.appending(
                    result.items,
                    to: state.uiModel.events,
                    id: \.id
                )
                state.eventsHasMore = result.hasMore
                state.eventsPagesLoaded += 1
            } catch {
                state.eventsHasMore = false
                postError(error)
            }
        }
    }
    
    private func loadMoreHangouts() {
        guard !isLoadingMoreHangouts, state.hangoutsHasMore else { return }
        isLoadingMoreHangouts = true
        let nextPage = hangoutsPage + 1

        Task {
            defer { isLoadingMoreHangouts = false }
            do {
                let result = try await dependencies.useCase.fetchHangouts(
                    query: makeQuery(page: nextPage)
                )
                hangoutsPage = result.page
                state.uiModel.hangouts = Self.appending(
                    result.items,
                    to: state.uiModel.hangouts,
                    id: \.id
                )
                state.hangoutsHasMore = result.hasMore
                state.hangoutsPagesLoaded += 1
            } catch {
                state.hangoutsHasMore = false
                postError(error)
            }
        }
    }

    /// Appends a page, dropping rows already on screen. The server re-sorts by
    /// `modifiedAt`, so a row can shift across the page boundary and arrive twice.
    private static func appending<Item, ID: Hashable>(
        _ newItems: [Item],
        to existing: [Item],
        id: (Item) -> ID
    ) -> [Item] {
        var seen = Set(existing.map(id))
        return existing + newItems.filter { seen.insert(id($0)).inserted }
    }
    
    private func searchChanged(_ text: String) {
        state.searchText = text
        clubsPage = 0
        eventsPage = 0
        hangoutsPage = 0

        searchTask?.cancel()
        searchTask = Task { [weak self] in
            guard let self else { return }
            try? await Task.sleep(nanoseconds: searchDebounceNanoseconds)
            guard !Task.isCancelled else { return }
            await getClubs()
            await getEvents()
            await getHangouts()
        }
    }

    private func makeQuery(page: Int) -> GroupsDTOModel.PaginationQuery {
        .init(
            page: page,
            size: Self.pageSize,
            keyword: currentKeyword
        )
    }

    private var currentKeyword: String? {
        let keyword = state.searchText
            .trimmingCharacters(in: .whitespacesAndNewlines)
        return keyword.isEmpty ? nil : keyword
    }
    
    private func postError(_ error: any Error) {
        guard let apiError = error as? APIError else { return }
        postEffect(.error(apiError))
    }
}
