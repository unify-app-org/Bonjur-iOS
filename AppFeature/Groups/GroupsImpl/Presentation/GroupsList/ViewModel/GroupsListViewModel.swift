//
//  GroupsListViewModel.swift
//  GroupsImpl
//
//  Created by Huseyn Hasanov on 23.01.26.
//

import AppFoundation

final class GroupsListViewModel: UIFeatureViewModel<GroupsListFeature> {
    
    struct Dependencies {
        let useCase: GroupsUseCase
    }
    
    private let router: GroupsListRouterProtocol
    private let inputData: GroupsListInputData
    private let dependencies: GroupsListViewModel.Dependencies
    
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
        case .clubItemTapped(let id):
            Task {
                await router.navigate(to: .clubDetail(id: id))
            }
        case .eventItemTapped(let id):
            Task {
                await router.navigate(to: .eventDetail(id: id))
            }
            
        }
    }
    
    private func fetchData() {
        Task {
            await getClubs()
            await getEvents()
            await getHangouts()
        }
    }
    
    private func getClubs() async {
        do {
            state.uiModel.clubs = try await dependencies.useCase.fetchClubs()
        } catch {
            postEffect(.error(error))
        }
    }
    
    private func getEvents() async {
        do {
            state.uiModel.events = try await dependencies.useCase.fetchEvents()
        } catch {
            postEffect(.error(error))
        }
    }
    
    private func getHangouts() async {
        do {
            state.uiModel.hangouts = try await dependencies.useCase.fetchHangouts()
        } catch {
            postEffect(.error(error))
        }
    }
}
