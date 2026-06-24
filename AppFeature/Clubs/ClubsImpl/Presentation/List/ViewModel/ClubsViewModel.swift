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
    private var clubsSize = 10
    private var isLoadingMoreClubs = false
    private var hasMoreClubs = true
    private var sourceClubs: [ClubCardView.Model] = []
    private var selectedCategoryIds: [Int] = []
    
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
    
    private func getClubs() async throws {
        postEffect(.loading(true))
        defer {
            postEffect(.loading(false))
        }
        do {
            let data = try await dependencies.useCase.fetchClubsData(
                query: makeQuery()
            )
            hasMoreClubs = data.count >= clubsSize
            sourceClubs = data
            applySearch()
        } catch {
            postEffect(.error(error))
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
                let previousCount = sourceClubs.count
                let clubs = try await dependencies.useCase.fetchClubsData(
                    query: makeQuery()
                )
                hasMoreClubs = clubs.count > previousCount
                sourceClubs = clubs
                applySearch()
            } catch {
                clubsSize = previousSize
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
            state.uiModel.clubs = sourceClubs
            return
        }

        state.uiModel.clubs = sourceClubs.filter { club in
            club.name.lowercased().contains(query)
            || club.communityName.lowercased().contains(query)
            || club.community.lowercased().contains(query)
        }
    }

    private func makeQuery() -> ClubDTOModel.PaginationQuery {
        let name = state.searchText
            .trimmingCharacters(in: .whitespacesAndNewlines)

        return .init(
            page: 0,
            size: clubsSize,
            name: name.isEmpty ? nil : name,
            categoryIds: selectedCategoryIds.isEmpty ? nil : selectedCategoryIds
        )
    }
}
