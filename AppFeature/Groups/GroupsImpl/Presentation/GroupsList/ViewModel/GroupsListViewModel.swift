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
    private let paginationStep = 10
    private let searchDebounceNanoseconds: UInt64 = 300_000_000
    private var clubsSize = 10
    private var hangoutsSize = 10
    private var isLoadingMoreClubs = false
    private var isLoadingMoreHangouts = false
    private var hasMoreClubs = true
    private var hasMoreHangouts = true
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
            let clubs = try await dependencies.useCase.fetchClubs(
                query: makeQuery(size: clubsSize)
            )
            hasMoreClubs = clubs.count >= clubsSize
            state.uiModel.clubs = clubs
        } catch {
            postError(error)
        }
    }

    private func getEvents() async {
        do {
            state.uiModel.events = try await dependencies.useCase.fetchEvents(
                keyword: currentKeyword
            )
        } catch {
            postError(error)
        }
    }

    private func getHangouts() async {
        do {
            let hangouts = try await dependencies.useCase.fetchHangouts(
                query: makeQuery(size: hangoutsSize)
            )
            hasMoreHangouts = hangouts.count >= hangoutsSize
            state.uiModel.hangouts = hangouts
        } catch {
            postError(error)
        }
    }
    
    private func loadMoreClubs() {
        guard !isLoadingMoreClubs, hasMoreClubs else { return }
        isLoadingMoreClubs = true
        let previousSize = clubsSize
        clubsSize += paginationStep
        
        Task {
            defer {
                isLoadingMoreClubs = false
            }
            
            do {
                let previousCount = state.uiModel.clubs.count
                let clubs = try await dependencies.useCase.fetchClubs(
                    query: makeQuery(size: clubsSize)
                )
                hasMoreClubs = clubs.count > previousCount
                state.uiModel.clubs = clubs
            } catch {
                clubsSize = previousSize
                postError(error)
            }
        }
    }
    
    private func loadMoreHangouts() {
        guard !isLoadingMoreHangouts, hasMoreHangouts else { return }
        isLoadingMoreHangouts = true
        let previousSize = hangoutsSize
        hangoutsSize += paginationStep
        
        Task {
            defer {
                isLoadingMoreHangouts = false
            }
            
            do {
                let previousCount = state.uiModel.hangouts.count
                let hangouts = try await dependencies.useCase.fetchHangouts(
                    query: makeQuery(size: hangoutsSize)
                )
                hasMoreHangouts = hangouts.count > previousCount
                state.uiModel.hangouts = hangouts
            } catch {
                hangoutsSize = previousSize
                postError(error)
            }
        }
    }
    
    private func searchChanged(_ text: String) {
        state.searchText = text
        clubsSize = paginationStep
        hangoutsSize = paginationStep
        hasMoreClubs = true
        hasMoreHangouts = true

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

    private func makeQuery(size: Int) -> GroupsDTOModel.PaginationQuery {
        .init(
            page: 0,
            size: size,
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
