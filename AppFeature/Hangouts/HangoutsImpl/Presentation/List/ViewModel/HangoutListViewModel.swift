//
//  HangoutListViewModel.swift
//  HangoutsImpl
//
//  Created by Huseyn Hasanov on 22.01.26.
//

import AppUIKit
import AppFoundation
import AppNetwork

final class HangoutListViewModel: UIFeatureViewModel<HangoutListFeature> {
    
    struct Dependencies {
        let useCase: HangoutsUseCase
    }
    
    private let router: HangoutListRouterProtocol
    private let inputData: HangoutListInputData
    private let dependencies: HangoutListViewModel.Dependencies
    private let paginationStep = 10
    private let searchDebounceNanoseconds: UInt64 = 300_000_000
    private var hangoutsSize = 10
    private var isLoadingMoreHangouts = false
    private var hasMoreHangouts = true
    private var selectedCategoryIds: [Int] = []
    private var searchTask: Task<Void, Never>?
    
    init(
        state: HangoutListFeature.State,
        router: HangoutListRouterProtocol,
        inputData: HangoutListInputData,
        dependencies: HangoutListViewModel.Dependencies
    ) {
        self.router = router
        self.inputData = inputData
        self.dependencies = dependencies
        super.init(initialState: state)
    }
    
    override func handle(action: HangoutListFeature.Action) {
        switch action {
        case .fetchData:
            fetchData()
        case .fetchCategories:
            fetchCategories()
        case .filtersSelected(let items):
            filtersSelected(items)
        case .loadMore:
            loadMoreHangouts()
        case .searchChanged(let text):
            searchChanged(text)
        case .itemTapped(let id):
            Task {
                await router.navigate(to: .details(hangoutId: id))
            }
        case .createTapped:
            Task {
                await router.navigate(to: .createHangout)
            }
        }
    }

    private func fetchData() {
        Task {
            await getHangoutsData()
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
        hangoutsSize = paginationStep
        hasMoreHangouts = true

        Task {
            await getHangoutsData()
        }
    }
    
    private func getHangoutsData() async {
        if state.uiModel.hangouts.isEmpty { state.isLoading = true }
        defer { state.isLoading = false }
        do {
            let hangouts = try await dependencies.useCase.fetchHangouts(
                query: makeQuery()
            )
            hasMoreHangouts = hangouts.count >= hangoutsSize
            state.uiModel.hangouts = hangouts
        } catch {
            print(error)
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
                    query: makeQuery()
                )
                hasMoreHangouts = hangouts.count > previousCount
                state.uiModel.hangouts = hangouts
            } catch {
                hangoutsSize = previousSize
                print(error)
            }
        }
    }

    private func searchChanged(_ text: String) {
        state.searchText = text
        hangoutsSize = paginationStep
        hasMoreHangouts = true

        searchTask?.cancel()
        searchTask = Task { [weak self] in
            guard let self else { return }
            try? await Task.sleep(nanoseconds: searchDebounceNanoseconds)
            guard !Task.isCancelled else { return }
            await getHangoutsData()
        }
    }

    private func makeQuery() -> HangoutsDTOModel.PaginationQuery {
        let keyword = state.searchText
            .trimmingCharacters(in: .whitespacesAndNewlines)

        return .init(
            page: 0,
            size: hangoutsSize,
            keyword: keyword.isEmpty ? nil : keyword,
            categoryIds: selectedCategoryIds.isEmpty ? nil : selectedCategoryIds
        )
    }
}
