// 
//  ModuleImpl.swift
//  Profile
//
//  Created by Huseyn Hasanov on 04.02.26.
//

import Foundation
import Profile
import AppNetwork
import AppWidgetShared
import DependecyInjection

struct ProfileModuleImpl: ProfileModule {
    
    func makeProfileViewController(
        userId: String?,
        communityId: Int?
    ) -> AnyObject {
        ProfileDetailBuilder(
            inputData: .init(
                userId: userId,
                communityId: communityId
            )
        ).build()
    }

    func publishWidgetCardIfNeeded() {
        guard UserCardWidgetStore.load() == nil else { return }
        Task {
            let tokenManager: TokenManager = resolve()
            let userId = await tokenManager.getUserId()
            guard !userId.isEmpty else { return }
            let useCase: ProfileUseCase = resolve()
            // `userId: nil` = "me", scoped to the community stored at login.
            guard let model = try? await useCase.getProfileData(
                userId: nil,
                communityId: nil
            ) else { return }
            UserCardWidgetPublisher.publish(card: model.userCardModel, userId: userId)
        }
    }
}
