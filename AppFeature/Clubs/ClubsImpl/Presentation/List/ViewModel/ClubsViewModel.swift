//
//  ClubsViewModel.swift
//  ClubsImpl
//
//  Created by Huseyn Hasanov on 17.01.26.
//

import AppUIKit
import AppFoundation
import AppNetwork

final class ClubsViewModel: UIFeatureViewModel<ClubsFeature> {
    
    struct Dependencies {
        let useCase: ClubsUseCase
    }
    
    private let router: ClubsRouterProtocol
    private let inputData: ClubsInputData
    private let dependencies: ClubsViewModel.Dependencies
    private let paginationStep = 10
    private let searchDebounceNanoseconds: UInt64 = 300_000_000
    private var clubsSize = 10
    private var isLoadingMoreClubs = false
    private var hasMoreClubs = true
    private var selectedCategoryIds: [Int] = []
    private var searchTask: Task<Void, Never>?
    
    init(
        state: ClubsFeature.State,
        router: ClubsRouterProtocol,
        inputData: ClubsInputData,
        dependencies: ClubsViewModel.Dependencies
    ) {
        self.router = router
        self.inputData = inputData
        self.dependencies = dependencies
        super.init(initialState: state)
    }
    
    override func handle(action: ClubsFeature.Action) {
        switch action {
        case .fetchData:
            fetchData()
        case .fetchCategories:
            fetchCategories()
        case .filtersSelected(let items):
            filtersSelected(items)
        case .loadMore:
            loadMoreClubs()
        case .searchChanged(let text):
            searchChanged(text)
        case .itemOnTap(let id):
            Task {
                await router.navigate(to: .showDetails(clubId: id))
            }
        case .createTapped:
            Task {
                await router.navigate(to: .createClub)
            }
        }
    }

    private func fetchData() {
        Task {
            try await getClubs()
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
        clubsSize = paginationStep
        hasMoreClubs = true

        Task {
            try await getClubs()
        }
    }
    
    private func getClubs(showLoading: Bool = true) async throws {
        if showLoading {
            postEffect(.loading(true))
        }
        defer {
            if showLoading {
                postEffect(.loading(false))
            }
        }
        do {
            let data = try await dependencies.useCase.fetchClubsData(
                query: makeQuery()
            )
            hasMoreClubs = data.count >= clubsSize
            state.uiModel.clubs = data
        } catch {
            print(error)
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
                let clubs = try await dependencies.useCase.fetchClubsData(
                    query: makeQuery()
                )
                hasMoreClubs = clubs.count > previousCount
                state.uiModel.clubs = clubs
            } catch {
                clubsSize = previousSize
                print(error)
            }
        }
    }

    private func searchChanged(_ text: String) {
        state.searchText = text
        clubsSize = paginationStep
        hasMoreClubs = true

        searchTask?.cancel()
        searchTask = Task { [weak self] in
            guard let self else { return }
            try? await Task.sleep(nanoseconds: searchDebounceNanoseconds)
            guard !Task.isCancelled else { return }
            try? await getClubs(showLoading: false)
        }
    }

    private func makeQuery() -> ClubDTOModel.PaginationQuery {
        let keyword = state.searchText
            .trimmingCharacters(in: .whitespacesAndNewlines)

        return .init(
            page: 0,
            size: clubsSize,
            keyword: keyword.isEmpty ? nil : keyword,
            categoryIds: selectedCategoryIds.isEmpty ? nil : selectedCategoryIds
        )
    }
}
