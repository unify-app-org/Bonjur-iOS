//
//  DiscoverViewModel.swift
//  DiscoverImpl
//
//  Created by Huseyn Hasanov on 11.01.26.
//
import Clubs
import Events
import Hangouts
import AppUIKit
import AppNetwork
import Communities
import AppFoundation

final class DiscoverViewModel: UIFeatureViewModel<DiscoverFeature> {
    
    struct Dependencies {
        let useCase: DiscoverUseCase
    }
    
    private let router: DiscoverRouterProtocol
    private let inputData: DiscoverInputData
    private let dependencies: DiscoverViewModel.Dependencies
    
    private let paginationStep = 10
    private var communitiesSize = 10
    private var clubsSize = 10
    private var eventsSize = 10
    private var hangoutsSize = 10
    private var isLoadingMoreCommunities = false
    private var isLoadingMoreClubs = false
    private var isLoadingMoreEvents = false
    private var isLoadingMoreHangouts = false
    private var hasMoreCommunities = true
    private var hasMoreClubs = true
    private var hasMoreEvents = true
    private var hasMoreHangouts = true
    private var selectedCategoryIds: [Int] = []
    
    private struct InitialFetchResults {
        let user: APIResult<UserModel>
        let filters: APIResult<[FilterView.Model]>
        let communities: APIResult<[CommunitiesModuleModel.CardInputData]>
        let clubs: APIResult<[ClubsModuleModel.CardInputData]>
        let events: APIResult<[EventsModuleModel.CardInputData]>
        let hangouts: APIResult<[HangoutsModuleModel.CardInputData]>
    }
    
    private struct FilteredFetchResults {
        let communities: APIResult<[CommunitiesModuleModel.CardInputData]>
        let clubs: APIResult<[ClubsModuleModel.CardInputData]>
        let events: APIResult<[EventsModuleModel.CardInputData]>
        let hangouts: APIResult<[HangoutsModuleModel.CardInputData]>
    }
    
    init(
        state: DiscoverFeature.State,
        router: DiscoverRouterProtocol,
        inputData: DiscoverInputData,
        dependencies: DiscoverViewModel.Dependencies
    ) {
        self.router = router
        self.inputData = inputData
        self.dependencies = dependencies
        super.init(initialState: state)
    }
    
    override func handle(action: DiscoverFeature.Action) {
        switch action {
        case .fetchData:
            fetchData()
        case .refreshActivities:
            refreshActivities()
        case .filtersSelected(let items):
            filtersSelected(items)
        case .loadMore(let activity):
            loadMore(activity)
        case .profileTapped:
            Task {
                await router.navigate(
                    to: .profile
                )
            }
        case .viewAllTapped(let activity):
            viewAllTapped(activity)
        case .clubItemOnTap(let id):
            Task {
                await router.navigate(to: .clubsDetails(id: id))
            }
        case .eventItemOnTap(let id):
            Task {
                await router.navigate(to: .eventsDetails(id: id))
            }
        case .hangoutsItemOnTap(let id):
            Task {
                await router.navigate(to: .hangoutsDetails(id: id))
            }
        case .communityItemOnTap(let id):
            Task {
                await router.navigate(to: .communityDetails(id: id))
            }
        case .joinHangout(let id):
            Task {
                await joinHangout(id: id)
            }
        }
    }
    
    private func fetchData() {
        Task {
            postEffect(.loading(true))
            defer {
                postEffect(.loading(false))
            }
            
            let results = await fetchInitialData()
            let firstError = await applyInitialFetchResults(results)
            publishActivityCounts()
            
            if let firstError {
                postEffect(.error(firstError))
            }
        }
    }
    
    private func joinHangout(id: String) async {
        postEffect(.loading(true))
        defer {
            postEffect(.loading(false))
        }
        do {
            _ = try await dependencies.useCase.joinHangout(
                request: .init(
                    hangoutId: id
                )
            )
            let data = try await dependencies.useCase.fetchHangoutsData(
                query: .init(page: 0, size: hangoutsSize)
            )
            await handleJoinHangout(
                data: data
            )
        } catch {
            postEffect(.error(error))
        }
    }
    
    @MainActor
    private func handleJoinHangout(
        data: [HangoutsModuleModel.CardInputData]
    ) {
        state.uiModel.hangouts = data
    }
    
    private func fetchInitialData() async -> InitialFetchResults {
        async let user = apiResult {
            try await dependencies.useCase.fetchUserData()
        }
        async let filters = apiResult {
            try await dependencies.useCase.fetchCategories()
        }
        async let communities = apiResult {
            try await dependencies.useCase.fetchCommunitiesData(
                query: paginationQuery(size: communitiesSize)
            )
        }
        async let clubs = apiResult {
            try await dependencies.useCase.fetchClubsData(
                query: paginationQuery(size: clubsSize)
            )
        }
        async let events = apiResult {
            try await dependencies.useCase.fetchEventsData(
                query: paginationQuery(size: eventsSize)
            )
        }
        async let hangouts = apiResult {
            try await dependencies.useCase.fetchHangoutsData(
                query: paginationQuery(size: hangoutsSize)
            )
        }
        
        return await .init(
            user: user,
            filters: filters,
            communities: communities,
            clubs: clubs,
            events: events,
            hangouts: hangouts
        )
    }
    
    @MainActor
    private func applyInitialFetchResults(
        _ results: InitialFetchResults
    ) -> APIError? {
        var firstError: APIError?
        
        switch results.user {
        case .success(let user):
            state.uiModel.user = user
        case .failure(let error):
            firstError = firstError ?? error
        }
        
        switch results.filters {
        case .success(let filters):
            state.uiModel.filters = applySelectedCategoryIds(to: filters)
        case .failure(let error):
            firstError = firstError ?? error
        }
        
        switch results.communities {
        case .success(let communities):
            state.uiModel.communities = communities
            hasMoreCommunities = communities.count >= communitiesSize
        case .failure(let error):
            firstError = firstError ?? error
        }
        
        switch results.clubs {
        case .success(let clubs):
            state.uiModel.clubs = clubs
            hasMoreClubs = clubs.count >= clubsSize
        case .failure(let error):
            firstError = firstError ?? error
        }
        
        switch results.events {
        case .success(let events):
            state.uiModel.events = events
            hasMoreEvents = events.count >= eventsSize
        case .failure(let error):
            firstError = firstError ?? error
        }
        
        switch results.hangouts {
        case .success(let hangouts):
            state.uiModel.hangouts = hangouts
            hasMoreHangouts = hangouts.count >= hangoutsSize
        case .failure(let error):
            firstError = firstError ?? error
        }
        
        return firstError
    }
    
    private func filtersSelected(_ items: [FilterView.Items]) {
        selectedCategoryIds = items.map(\.id)
        state.uiModel.filters = applySelectedCategoryIds(to: state.uiModel.filters)
        resetPagination()
        
        Task {
            postEffect(.loading(true))
            defer {
                postEffect(.loading(false))
            }
            
            let results = await fetchFilteredData()
            let firstError = applyFilteredFetchResults(results)
            publishActivityCounts()
            
            if let firstError {
                postEffect(.error(firstError))
            }
        }
    }
    
    /// Refetch only the 4 activity sections (communities/clubs/events/hangouts)
    /// when Discover reappears, so changes made in a detail screen (join/request/
    /// exit/edit) show up. Reuses the filtered path so the active filter and the
    /// current page depth are preserved. User + categories are NOT refetched.
    private func refreshActivities() {
        Task {
            postEffect(.loading(true))
            defer {
                postEffect(.loading(false))
            }

            let results = await fetchFilteredData()
            let firstError = applyFilteredFetchResults(results)
            publishActivityCounts()

            if let firstError {
                postEffect(.error(firstError))
            }
        }
    }

    private func fetchFilteredData() async -> FilteredFetchResults {
        async let communities = apiResult {
            try await dependencies.useCase.fetchCommunitiesData(
                query: paginationQuery(size: communitiesSize)
            )
        }
        async let clubs = apiResult {
            try await dependencies.useCase.fetchClubsData(
                query: paginationQuery(size: clubsSize)
            )
        }
        async let events = apiResult {
            try await dependencies.useCase.fetchEventsData(
                query: paginationQuery(size: eventsSize)
            )
        }
        async let hangouts = apiResult {
            try await dependencies.useCase.fetchHangoutsData(
                query: paginationQuery(size: hangoutsSize)
            )
        }

        return await .init(
            communities: communities,
            clubs: clubs,
            events: events,
            hangouts: hangouts
        )
    }
    
    private func applyFilteredFetchResults(
        _ results: FilteredFetchResults
    ) -> APIError? {
        var firstError: APIError?
        
        switch results.communities {
        case .success(let communities):
            state.uiModel.communities = communities
            hasMoreCommunities = communities.count >= communitiesSize
        case .failure(let error):
            firstError = firstError ?? error
        }
        
        switch results.clubs {
        case .success(let clubs):
            state.uiModel.clubs = clubs
            hasMoreClubs = clubs.count >= clubsSize
        case .failure(let error):
            firstError = firstError ?? error
        }

        switch results.events {
        case .success(let events):
            state.uiModel.events = events
            hasMoreEvents = events.count >= eventsSize
        case .failure(let error):
            firstError = firstError ?? error
        }

        switch results.hangouts {
        case .success(let hangouts):
            state.uiModel.hangouts = hangouts
            hasMoreHangouts = hangouts.count >= hangoutsSize
        case .failure(let error):
            firstError = firstError ?? error
        }

        return firstError
    }

    private func resetPagination() {
        communitiesSize = paginationStep
        clubsSize = paginationStep
        eventsSize = paginationStep
        hangoutsSize = paginationStep
        hasMoreCommunities = true
        hasMoreClubs = true
        hasMoreEvents = true
        hasMoreHangouts = true
    }
    
    private func paginationQuery(
        size: Int
    ) -> DiscoverDTOModel.PaginationQuery {
        .init(
            page: 0,
            size: size,
            categoryIds: selectedCategoryIds.isEmpty ? nil : selectedCategoryIds
        )
    }
    
    private func applySelectedCategoryIds(
        to filters: [FilterView.Model]
    ) -> [FilterView.Model] {
        filters.applyingSelectedItemIds(selectedCategoryIds)
    }

    private func loadMore(_ type: AppUIEntities.ActivityType) {
        switch type {
        case .community:
            loadMoreCommunities()
        case .clubs:
            loadMoreClubs()
        case .hangOuts:
            loadMoreHangouts()
        case .events:
            loadMoreEvents()
        }
    }
    
    private func loadMoreCommunities() {
        guard !isLoadingMoreCommunities, hasMoreCommunities else { return }
        isLoadingMoreCommunities = true
        let previousSize = communitiesSize
        communitiesSize += paginationStep
        
        Task {
            defer {
                isLoadingMoreCommunities = false
            }
            
            do {
                let communities = try await dependencies.useCase.fetchCommunitiesData(
                    query: paginationQuery(size: communitiesSize)
                )
                hasMoreCommunities = communities.count > state.uiModel.communities.count
                state.uiModel.communities = communities
            } catch {
                communitiesSize = previousSize
                postEffect(.error(error as? APIError))
            }
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
                let clubs = try await dependencies.useCase.fetchClubsData(
                    query: paginationQuery(size: clubsSize)
                )
                hasMoreClubs = clubs.count > state.uiModel.clubs.count
                state.uiModel.clubs = clubs
            } catch {
                clubsSize = previousSize
                postEffect(.error(error as? APIError))
            }
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
                let events = try await dependencies.useCase.fetchEventsData(
                    query: paginationQuery(size: eventsSize)
                )
                hasMoreEvents = events.count > state.uiModel.events.count
                state.uiModel.events = events
            } catch {
                eventsSize = previousSize
                postEffect(.error(error as? APIError))
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
                let hangouts = try await dependencies.useCase.fetchHangoutsData(
                    query: paginationQuery(size: hangoutsSize)
                )
                hasMoreHangouts = hangouts.count > state.uiModel.hangouts.count
                state.uiModel.hangouts = hangouts
                publishActivityCounts()
            } catch {
                hangoutsSize = previousSize
                postEffect(.error(error as? APIError))
            }
        }
    }
    
    private func viewAllTapped(_ type: AppUIEntities.ActivityType) {
        switch type {
        case .community:
            break
        case .events:
            Task {
                await router.navigate(to: .viewAllEvents)
            }
        case .clubs:
            Task {
                await router.navigate(to: .viewAllClubs)
            }
        case .hangOuts:
            Task {
                await router.navigate(to: .viewAllHangouts)
            }
        }
    }
    
    private func publishActivityCounts() {
        let joinedEvents = state.uiModel.events.filter {
            $0.requestType == .joined
        }.count
        let joinedHangouts = state.uiModel.hangouts.filter {
            $0.requestType == .joined
        }.count
        
        Task {
            await router.navigate(
                to: .activityCountsUpdated(
                    events: joinedEvents,
                    hangouts: joinedHangouts
                )
            )
        }
    }
    
}
