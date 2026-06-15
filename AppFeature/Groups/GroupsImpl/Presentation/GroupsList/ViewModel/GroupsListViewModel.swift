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
    private var clubsSize = 10
    private var hangoutsSize = 10
    private var isLoadingMoreClubs = false
    private var isLoadingMoreHangouts = false
    private var hasMoreClubs = true
    private var hasMoreHangouts = true
    private var sourceClubs: [ClubsModuleModel.CardInputData] = []
    private var sourceEvents: [EventsModuleModel.CardInputData] = []
    private var sourceHangouts: [HangoutsModuleModel.CardInputData] = []
    
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
            sourceClubs = clubs
            applyClubsSearch()
        } catch {
            postError(error)
        }
    }
    
    private func getEvents() async {
        do {
            sourceEvents = try await dependencies.useCase.fetchEvents()
            applyEventsSearch()
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
            sourceHangouts = hangouts
            applyHangoutsSearch()
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
                let previousCount = sourceClubs.count
                let clubs = try await dependencies.useCase.fetchClubs(
                    query: makeQuery(size: clubsSize)
                )
                hasMoreClubs = clubs.count > previousCount
                sourceClubs = clubs
                applyClubsSearch()
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
                let previousCount = sourceHangouts.count
                let hangouts = try await dependencies.useCase.fetchHangouts(
                    query: makeQuery(size: hangoutsSize)
                )
                hasMoreHangouts = hangouts.count > previousCount
                sourceHangouts = hangouts
                applyHangoutsSearch()
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
        
        applyClubsSearch()
        applyEventsSearch()
        applyHangoutsSearch()
        
        Task {
            await getClubs()
            await getHangouts()
        }
    }
    
    private func applyClubsSearch() {
        let query = searchQuery
        
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
    
    private func applyEventsSearch() {
        let query = searchQuery
        
        guard !query.isEmpty else {
            state.uiModel.events = sourceEvents
            return
        }
        
        state.uiModel.events = sourceEvents.filter { event in
            event.name.lowercased().contains(query)
            || event.club.name.lowercased().contains(query)
            || event.tags.contains { $0.title.lowercased().contains(query) }
        }
    }
    
    private func applyHangoutsSearch() {
        let query = searchQuery
        
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
    
    private func makeQuery(size: Int) -> GroupsDTOModel.PaginationQuery {
        let name = state.searchText
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        return .init(
            page: 0,
            size: size,
            name: name.isEmpty ? nil : name
        )
    }
    
    private var searchQuery: String {
        state.searchText
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
    }
    
    private func postError(_ error: any Error) {
        guard let apiError = error as? APIError else { return }
        postEffect(.error(apiError))
    }
}
