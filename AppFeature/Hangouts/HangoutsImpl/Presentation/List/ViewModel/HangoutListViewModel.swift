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
    private var hangoutsSize = 10
    private var isLoadingMoreHangouts = false
    private var hasMoreHangouts = true
    private var sourceHangouts: [HangoutsCardView.Model] = []
    private var selectedCategoryIds: [Int] = []
    
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
        do {
            let hangouts = try await dependencies.useCase.fetchHangouts(
                query: makeQuery()
            )
            hasMoreHangouts = hangouts.count >= hangoutsSize
            sourceHangouts = hangouts
            applySearch()
        } catch {
            postEffect(.error(error))
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
                let previousCount = sourceHangouts.count
                let hangouts = try await dependencies.useCase.fetchHangouts(
                    query: makeQuery()
                )
                hasMoreHangouts = hangouts.count > previousCount
                sourceHangouts = hangouts
                applySearch()
            } catch {
                hangoutsSize = previousSize
                postEffect(.error(error as! APIError))
            }
        }
    }

    private func searchChanged(_ text: String) {
        state.searchText = text
        applySearch()
    }

    private func applySearch() {
        let query = state.searchText
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()

        guard !query.isEmpty else {
            state.uiModel.hangouts = sourceHangouts
            return
        }

        state.uiModel.hangouts = sourceHangouts.filter { hangout in
            hangout.name.lowercased().contains(query)
            || hangout.description.lowercased().contains(query)
            || hangout.tags.contains { $0.title.lowercased().contains(query) }
        }
    }

    private func makeQuery() -> HangoutsDTOModel.PaginationQuery {
        let name = state.searchText
            .trimmingCharacters(in: .whitespacesAndNewlines)

        return .init(
            page: 0,
            size: hangoutsSize,
            name: name.isEmpty ? nil : name,
            categoryIds: selectedCategoryIds.isEmpty ? nil : selectedCategoryIds
        )
    }
}
