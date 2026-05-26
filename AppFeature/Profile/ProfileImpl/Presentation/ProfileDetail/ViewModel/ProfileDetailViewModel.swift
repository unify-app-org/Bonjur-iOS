//
//  ProfileDetailViewModel.swift
//  ProfileImpl
//
//  Created by Huseyn Hasanov on 04.02.26.
//

import AppFoundation
import AppUIKit
import AppNetwork
import Clubs
import Hangouts

final class ProfileDetailViewModel: UIFeatureViewModel<ProfileDetailFeature> {
    
    struct Dependencies {
        let useCase: ProfileUseCase
    }
    
    private let router: ProfileDetailRouterProtocol
    private let inputData: ProfileDetailInputData
    private let dependencies: ProfileDetailViewModel.Dependencies

    private struct InitialFetchResults {
        let user: APIResult<ProfileDetail.UIModel>
        let clubs: APIResult<[ClubsModuleModel.CardInputData]>
        let hangouts: APIResult<[HangoutsModuleModel.CardInputData]>
    }

    init(
        state: ProfileDetailFeature.State,
        router: ProfileDetailRouterProtocol,
        inputData: ProfileDetailInputData,
        dependencies: ProfileDetailViewModel.Dependencies
    ) {
        self.router = router
        self.inputData = inputData
        self.dependencies = dependencies
        super.init(initialState: state)
    }
    
    override func handle(action: ProfileDetailFeature.Action) {
        switch action {
        case .fetchData:
            fetchData()
        case .editProfile:
            Task {
                guard let uiModel = state.uiModel else { return }
                await router.navigate(
                    to: .editProfile(
                        .init(profileData: uiModel)
                    )
                )
            }
        case .clubsItemTapped(let id):
            Task {
                await router.navigate(to: .clubsDetails(id: id))
            }
        case .eventsItemTapped(let id):
            Task {
                await router.navigate(to: .eventsDetails(id: id))
            }
        case .hangoutsItemTapped(let id):
            Task {
                await router.navigate(to: .hangoutsDetails(id: id))
            }
        case .settingsTapped:
            Task {
                await router.navigate(to: .settings)
            }
        case .userCardTapped:
            guard let userCardModel = self.state.uiModel?.userCardModel else {
                return
            }
            Task {
                await router.navigate(
                    to: .studentCard(
                        .init(
                            userCardModel: userCardModel,
                            onSave: { [weak self] backgroundType in
                                self?.applyUserCardCover(backgroundType)
                            }
                        )
                    )
                )
            }
        case .userCardCoverSaved(let backgroundType):
            applyUserCardCover(backgroundType)
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
                postEffect(.error(firstError.localizedDescription, firstError.detail))
            }
        }
    }
    
    private func fetchInitialData() async -> InitialFetchResults {
        async let user = apiResult {
            try await dependencies.useCase.getProfileData(
                userId: inputData.userId
            )
        }
        async let clubs = apiResult {
            try await dependencies.useCase.getMyClubs(
                userId: inputData.userId
            )
        }
        async let hangouts = apiResult {
            try await dependencies.useCase.getMyHangouts(
                userId: inputData.userId
            )
        }
        
        return await .init(
            user: user,
            clubs: clubs,
            hangouts: hangouts
        )
    }
    
    private func applyInitialFetchResults(
        _ results: InitialFetchResults
    ) -> APIError? {
        var firstError: APIError?

        switch results.user {
        case .success(let user):
            state.uiModel = user
            if inputData.userId != nil {
                state.navigationTitle = "About user"
                state.isOtherUser = true
            }
        case .failure(let error):
            firstError = firstError ?? error
        }

        switch results.clubs {
        case .success(let clubs):
            state.clubs = clubs
        case .failure(let error):
            firstError = firstError ?? error
        }
        
        switch results.hangouts {
        case .success(let clubs):
            state.hangouts = clubs
        case .failure(let error):
            firstError = firstError ?? error
        }
        
        return firstError
    }
    
    private func editUser(
        _ request: ProfileDTOModel.UpdateRequest?
    ) async {
        postEffect(.loading(true))
        defer {
            postEffect(.loading(false))
        }
        do {
            _ = try await dependencies.useCase.editProfile(
                multiPart: nil,
                queryData: request
            )
        } catch {
            
        }
    }
    
    private func buildRequest(
        bgType: AppUIEntities.BackgroundType?
    ) -> (
        ProfileDTOModel.UpdateRequest?
    ) {
        let gender = state.uiModel?.gender?.type.rawValue ?? "-"
        let categories = state.uiModel?.tags.map({ $0.id }) ?? []
        let languages = state.uiModel?.languages?.map({ $0.id }) ?? []
        let birthDate = state.uiModel?.birthday ?? ""
        
        let request: ProfileDTOModel.UpdateRequest = .init(
            birthDate: birthDate,
            gender: gender,
            about: state.uiModel?.about ?? "",
            categoriesId: categories,
            languagesId: languages,
            background: bgType
        )
        return request
    }
    
    private func applyUserCardCover(_ backgroundType: AppUIEntities.BackgroundType?) {
        guard let currentUIModel = state.uiModel else {
            return
        }
        
        let updatedUserCardModel = UserCardModel(
            backgroundCover: backgroundType,
            nameSurname: currentUIModel.userCardModel.nameSurname,
            speciality: currentUIModel.userCardModel.speciality,
            course: currentUIModel.userCardModel.course,
            community: currentUIModel.userCardModel.community,
            degree: currentUIModel.userCardModel.degree,
            entryYear: currentUIModel.userCardModel.entryYear,
            email: currentUIModel.userCardModel.email,
            imageUrl: currentUIModel.userCardModel.imageUrl
        )
        
        let updatedUIModel = ProfileDetail.UIModel(
            userCardModel: updatedUserCardModel,
            about: currentUIModel.about,
            gender: currentUIModel.gender,
            birthday: currentUIModel.birthday,
            languages: currentUIModel.languages,
            tags: currentUIModel.tags
        )
        
        state.uiModel = updatedUIModel
        
        let request = buildRequest(bgType: backgroundType)
        Task {
            await editUser(request)
        }
    }
}
