//
//  ClubDetailsViewModel.swift
//  AppAuth
//
//  Created by Huseyn Hasanov on 29.01.26.
//

import AppFoundation
import Communities
import AppNetwork

final class ClubDetailsViewModel: UIFeatureViewModel<ClubDetailsFeature> {
    
    struct Dependencies {
        let useCase: ClubsUseCase
    }
    private struct InitialFetchResults {
        let detail: APIResult<ClubsDetailsModel.UIModel>
        let members: APIResult<CommunitiesMemberModuleModel.GroupedMembersData>
    }
    
    private let router: ClubDetailsRouterProtocol
    private let inputData: ClubDetailsInputData
    private let dependencies: ClubDetailsViewModel.Dependencies
    
    init(
        state: ClubDetailsFeature.State,
        router: ClubDetailsRouterProtocol,
        inputData: ClubDetailsInputData,
        dependencies: ClubDetailsViewModel.Dependencies
    ) {
        self.router = router
        self.inputData = inputData
        self.dependencies = dependencies
        super.init(initialState: state)
    }
    
    override func handle(action: ClubDetailsFeature.Action) {
        switch action {
        case .fetchData:
            fetchData()
        case .backTapped:
            Task { @MainActor in
                router.navigate(to: .backTapped)
            }
        case .editTapped:
            guard let prefillData = state.uiModel?.editPrefillData else {
                return
            }
            Task { @MainActor in
                router.navigate(
                    to: .editClub(
                        id: inputData.clubId,
                        prefillData: prefillData
                    )
                )
            }
        case .userTapped(let id):
            Task { @MainActor in
                router.navigate(to: .userDetail(id))
            }
        case .joinClubTapped:
            Task {
                await joinClub()
            }
        }
    }
    
    private func joinClub() async {
        postEffect(.loading(true))
        defer {
            postEffect(.loading(false))
        }
        do {
            _ = try await dependencies.useCase.joinClub(id: inputData.clubId)
            await handleJoinClub()
        } catch {
            postEffect(.error(error))
        }
    }
    
    @MainActor
    private func handleJoinClub() {
        fetchData()
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
            try await dependencies.useCase.fetchClubDetails(
                clubId: inputData.clubId
            )
        }
        async let members = apiResult {
            try await dependencies.useCase.fetchClubMemberById(
                id: inputData.clubId
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
        _ data: ClubsDetailsModel.UIModel
    ) {
        state.uiModel = data
    }
    
    @MainActor
    private func handleMembers(
        _ data: CommunitiesMemberModuleModel.GroupedMembersData
    ) {
        state.members = data
    }
}
