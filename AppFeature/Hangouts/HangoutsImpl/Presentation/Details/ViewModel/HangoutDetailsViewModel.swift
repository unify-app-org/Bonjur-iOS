//
//  HangoutDetailsViewModel.swift
//  HangoutsImpl
//
//  Created by Huseyn Hasanov on 02.02.26.
//

import AppFoundation
import Communities
import AppNetwork

final class HangoutDetailsViewModel: UIFeatureViewModel<HangoutDetailsFeature> {
    
    struct Dependencies {
        let useCase: HangoutsUseCase
    }
    
    private struct InitialFetchResults {
        let detail: APIResult<HangoutDetails.UIModel>
        let members: APIResult<CommunitiesMemberModuleModel.GroupedMembersData>
    }
    
    private let router: HangoutDetailsRouterProtocol
    private let inputData: HangoutDetailsInputData
    private let dependencies: HangoutDetailsViewModel.Dependencies
    
    init(
        state: HangoutDetailsFeature.State,
        router: HangoutDetailsRouterProtocol,
        inputData: HangoutDetailsInputData,
        dependencies: HangoutDetailsViewModel.Dependencies
    ) {
        self.router = router
        self.inputData = inputData
        self.dependencies = dependencies
        super.init(initialState: state)
    }
    
    override func handle(action: HangoutDetailsFeature.Action) {
        switch action {
        case .backTapped:
            Task {
                await router.navigate(to: .back)
            }
        case .fetchData:
            fetchData()
        }
    }
    
    private func getHangoutDetail() async {
        postEffect(.loading(true))
        defer {
            postEffect(.loading(false))
        }
        do {
            let data = try await dependencies.useCase.fetchDetailHangout(
                id: inputData.hangoutId
            )
            state.uiModel = data
        } catch {
            postEffect(.error(error))
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
            
            if let firstError {
                postEffect(.error(firstError))
            }
        }
    }
    
    private func fetchInitialData() async -> InitialFetchResults {
        async let detail = apiResult {
            try await dependencies.useCase.fetchDetailHangout(
                id: inputData.hangoutId
            )
        }
        async let members = apiResult {
            try await dependencies.useCase.fetchDetailHangoutMembers(
                id: inputData.hangoutId
            )
        }
        
        return await .init(
            detail: detail,
            members: members
        )
    }
    
    private func applyInitialFetchResults(
        _ results: InitialFetchResults
    ) -> APIError? {
        var firstError: APIError?
        
        switch results.detail {
        case .success(let detail):
            Task { @MainActor in
                handleUIModel(detail)
            }
        case .failure(let error):
            firstError = firstError ?? error
        }
        
        switch results.members {
        case .success(let members):
            Task { @MainActor in
                handleMembers(members)
            }
        case .failure(let error):
            firstError = firstError ?? error
        }
        return firstError
    }
    
    @MainActor
    private func handleUIModel(
        _ data: HangoutDetails.UIModel
    ) {
        state.uiModel = data
    }
    
    @MainActor
    private func handleMembers(
        _ data: CommunitiesMemberModuleModel.GroupedMembersData
    ) {
        state.membersData = data
    }
}
