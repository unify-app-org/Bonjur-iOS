//
//  ProfileDetailViewModel.swift
//  ProfileImpl
//
//  Created by Huseyn Hasanov on 04.02.26.
//

import AppFoundation
import AppUIKit

final class ProfileDetailViewModel: UIFeatureViewModel<ProfileDetailFeature> {
    
    struct Dependencies {
        let useCase: ProfileUseCase
    }
    
    private let router: ProfileDetailRouterProtocol
    private let inputData: ProfileDetailInputData
    private let dependencies: ProfileDetailViewModel.Dependencies
    
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
        case .userCardTapped:
            Task{
                if let userCardModel = self.state.uiModel?.userCardModel {
                    await router.navigate(to: .studentCard(.init(userCardModel: userCardModel, onSave: { [weak self] backgroundType in
                        self?.store.send(.userCardCoverSaved(backgroundType))
                    })))
                }
              
            }
        case .userCardCoverSaved(let backgroundType):
            applyUserCardCover(backgroundType)
        }
    }
    
    private func fetchData() {
        Task {
            await fetchUserData()
        }
    }
    
    private func fetchUserData() async {
        do {
            state.uiModel = try await dependencies.useCase.getProfileData()
        } catch {
            
        }
    }
    
    private func applyUserCardCover(_ backgroundType: AppUIEntities.BackgroundType) {
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
            tags: currentUIModel.tags,
            cardCover: backgroundType,
            clubs: currentUIModel.clubs,
            events: currentUIModel.events,
            hangouts: currentUIModel.hangouts
        )
        
        state.uiModel = updatedUIModel
    }
}
