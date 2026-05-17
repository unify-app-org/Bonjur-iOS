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
    
    private typealias FetchResult<T> = Result<T, Error>
    
    private struct InitialFetchResults {
        let user: FetchResult<UserModel>
        let filters: FetchResult<[FilterView.Model]>
        let communities: FetchResult<[CommunitiesModuleModel.CardInputData]>
        let clubs: FetchResult<[ClubsModuleModel.CardInputData]>
        let events: FetchResult<[EventsModuleModel.CardInputData]>
        let hangouts: FetchResult<[HangoutsModuleModel.CardInputData]>
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
        }
    }
    
    private func fetchData() {
        Task {
            postEffect(.loading(true))
            defer {
                postEffect(.loading(false))
            }
            
            let results = await fetchInitialData()
            let firstError = applyInitialFetchResults(results)
            publishActivityCounts()
            
            if let firstError {
                postEffect(.error(firstError as? APIError))
            }
        }
    }
    
    private func fetchInitialData() async -> InitialFetchResults {
        async let user = result {
            try await dependencies.useCase.fetchUserData()
        }
        async let filters = result {
            try await dependencies.useCase.fetchFilterData()
        }
        async let communities = result {
            try await dependencies.useCase.fetchCommunitiesData(
                query: .init(page: 0, size: communitiesSize)
            )
        }
        async let clubs = result {
            try await dependencies.useCase.fetchClubsData(
                query: .init(page: 0, size: clubsSize)
            )
        }
        async let events = result {
            try await dependencies.useCase.fetchEventsData()
        }
        async let hangouts = result {
            try await dependencies.useCase.fetchHangoutsData(
                query: .init(page: 0, size: hangoutsSize)
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
    
    private func applyInitialFetchResults(
        _ results: InitialFetchResults
    ) -> Error? {
        var firstError: Error?
        
        switch results.user {
        case .success(let user):
            state.uiModel.user = user
        case .failure(let error):
            firstError = firstError ?? error
        }
        
        switch results.filters {
        case .success(let filters):
            state.uiModel.filters = filters
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
            hasMoreEvents = events.count > state.uiModel.events.count
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
                    query: .init(page: 0, size: communitiesSize)
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
                    query: .init(page: 0, size: clubsSize)
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
                let events = try await dependencies.useCase.fetchEventsData()
                let visibleEvents = Array(events.prefix(eventsSize))
                hasMoreEvents = events.count > visibleEvents.count
                state.uiModel.events = visibleEvents
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
                    query: .init(page: 0, size: hangoutsSize)
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
    
    private func result<T>(
        _ operation: () async throws -> T
    ) async -> Result<T, Error> {
        do {
            return .success(try await operation())
        } catch {
            return .failure(error)
        }
    }
}
