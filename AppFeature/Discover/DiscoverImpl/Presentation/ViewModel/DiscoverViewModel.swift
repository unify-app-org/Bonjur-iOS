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
        }
    }
    
    private func fetchData() {
        Task {
            await fetchUsersData()
            await fetchFilterData()
            await fetchCommunitiesData()
            await fetchClubsData()
            await fetchEventsData()
            await fetchHangoutsData()
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
    
    private func fetchUsersData() async {
        postEffect(.loading(true))
        do {
            let data = try await dependencies.useCase.fetchUserData()
            handleUserData(data)
        } catch {
            postEffect(.error(error))
        }
    }
    
    private func handleUserData(_ data: UserModel) {
        state.uiModel.user = data
    }
    
    private func fetchCommunitiesData() async {
        do {
            let data = try await dependencies.useCase.fetchCommunitiesData()
            handleCommunitiesData(data)
        } catch {
            postEffect(.error(error))
        }
    }
    
    private func handleCommunitiesData(_ data: [CommunitiesModuleModel.CardInputData]) {
        state.uiModel.communities = data
    }
    
    private func fetchFilterData() async {
        do {
            let data = try await dependencies.useCase.fetchFilterData()
            handleFilterData(data)
        } catch {
            postEffect(.error(error))
        }
    }
    
    private func handleFilterData(_ data: [FilterView.Model]) {
        state.uiModel.filters = data
    }
    
    private func fetchClubsData() async {
        do {
            let data = try await dependencies.useCase.fetchClubsData()
            handleClubsData(data)
        } catch {
            postEffect(.error(error))
        }
    }
    
    private func handleClubsData(_ data: [ClubsModuleModel.CardInputData]) {
        state.uiModel.clubs = data
    }
    
    private func fetchEventsData() async {
        do {
            let data = try await dependencies.useCase.fetchEventsData()
            handleEventsData(data)
        } catch {
            postEffect(.error(error))
        }
    }
    
    private func handleEventsData(_ data: [EventsModuleModel.CardInputData]) {
        state.uiModel.events = data
    }
    
    private func fetchHangoutsData() async {
        defer {
            postEffect(.loading(false))
        }
        do {
            let data = try await dependencies.useCase.fetchHangoutsData()
            handleHangoutsData(data)
        } catch {
            postEffect(.error(error))
        }
    }
    
    private func handleHangoutsData(_ data: [HangoutsModuleModel.CardInputData]) {
        state.uiModel.hangouts = data
    }
}
