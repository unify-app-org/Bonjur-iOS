//
//  ChooseUniversityViewModel.swift
//  AppAuthImpl
//
//  Created by Huseyn Hasanov on 26.12.25.
//

import AppFoundation

final class ChooseUniversityViewModel: UIFeatureViewModel<ChooseUniversityFeature> {
    
    struct Dependencies {
        let useCase: AuthUsecases
    }
    
    private let router: ChooseUniversityRouterProtocol
    private let inputData: ChooseUniversityInputData
    private let dependencies: ChooseUniversityViewModel.Dependencies
    
    init(
        state: ChooseUniversityFeature.State,
        router: ChooseUniversityRouterProtocol,
        inputData: ChooseUniversityInputData,
        dependencies: ChooseUniversityViewModel.Dependencies
    ) {
        self.router = router
        self.inputData = inputData
        self.dependencies = dependencies
        super.init(initialState: state)
    }
    
    override func handle(action: ChooseUniversityFeature.Action) {
        switch action {
        case .fetchData:
            fetchData()
        case .selectedCell(let id):
            selectedCell(id)
        case .nextTapped:
            nextTapped()
        }
    }
    
    private func fetchData() {
        Task {
            await getCommunities()
        }
    }
    
    private func getCommunities() async {
        postEffect(.loading(true))
        defer {
            postEffect(.loading(false))
        }
        
        do {
            state.uiModel = try await dependencies.useCase.getCommunities()
        } catch {
            state.error = .init(
                title: error.localizedDescription,
                subtitle: error.detail
            )
        }
    }
    
    private func nextTapped() {
        guard let selectedItem = state.uiModel.first(where: { $0.selected == true }) else {
            return
        }
        Task {
            await router.navigate(to: .signIn(
                .init(communityId: selectedItem.id)
            ))
        }
    }
    
    private func selectedCell(_ id: Int) {
        state.uiModel = state.uiModel.map { reason in
            var updated = reason
            updated.selected = (reason.id == id)
            return updated
        }
    }
}
