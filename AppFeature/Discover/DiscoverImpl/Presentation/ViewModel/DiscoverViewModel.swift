//
//  DiscoverViewModel.swift
//  DiscoverImpl
//
//  Created by Huseyn Hasanov on 11.01.26.
//

import AppFoundation
import AppUIKit
import Clubs
import Events
import Hangouts
import Communities
import AppNetwork

final class DiscoverViewModel: UIFeatureViewModel<DiscoverFeature> {
    
    struct Dependencies {
        let useCase: DiscoverUseCase
    }
    
    private let router: DiscoverRouterProtocol
    private let inputData: DiscoverInputData
    private let dependencies: DiscoverViewModel.Dependencies
    
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
        case .profileTapped:
            Task {
                await router.navigate(to: .profile)
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
            
            async let userData = dependencies.useCase.fetchUserData()
            async let filterData = dependencies.useCase.fetchFilterData()
            async let communitiesData = dependencies.useCase.fetchCommunitiesData()
            async let clubsData = dependencies.useCase.fetchClubsData()
            async let eventsData = dependencies.useCase.fetchEventsData()
            async let hangoutsData = dependencies.useCase.fetchHangoutsData(
                query: .init(page: 0, size: 10)
            )
            
            do {
                let (user, filters, communities, clubs, events, hangouts) = try await (
                    userData,
                    filterData,
                    communitiesData,
                    clubsData,
                    eventsData,
                    hangoutsData
                )
                
                state.uiModel.user = user
                state.uiModel.filters = filters
                state.uiModel.communities = communities
                state.uiModel.clubs = clubs
                state.uiModel.events = events
                state.uiModel.hangouts = hangouts
                
                publishActivityCounts()
                
            } catch {
                postEffect(.error(error as! APIError))
            }
            
            postEffect(.loading(false))
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
