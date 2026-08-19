//
//  AuthUsecases.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 25.11.25.
//

import AppFoundation
import AppNetwork
import UIKit
import AppUIKit
import AppStorage

protocol AuthUsecases {
    
    func onboarding() -> [AuthUIModel.Onboarding]
        
    func welcome() -> AuthUIModel.Onboarding
        
    func genders() -> [SelectableListItemView.Model]
    
    func interests() async throws(APIError) -> [AuthUIModel.Interests]
    
    func login(
        communityId: Int,
        email: String,
        password: String?,
        idToken: String?
    ) async throws(APIError) -> Bool
    
    func getCommunities() async throws(APIError) -> [SelectableListItemView.Model]
    
    func sendOptionals(
        multiPart: MultipartFormData?,
        queryData: AuthDTOModel.OptionalsQuery?
    ) async throws(APIError) -> Data
    
    func getLanguages() async throws(APIError) -> [SelectableListItemView.Model]
}

final class AuthUsecasesImpl: AuthUsecases {
    
    private let repo: AuthRepo
    
    init(repo: AuthRepo = resolve()) {
        self.repo = repo
    }
    
    func onboarding() -> [AuthUIModel.Onboarding] {
        [
            .init(
                title: "auth_onboarding_1_title".localized,
                subtitle: "auth_onboarding_1_subtitle".localized,
                image: UIImage.Icons.bigGraduationHat
            ),
            .init(
                title: "auth_onboarding_2_title".localized,
                subtitle: "auth_onboarding_2_subtitle".localized,
                image: UIImage.Icons.bigLamps
            ),
            .init(
                title: "auth_onboarding_3_title".localized,
                subtitle: "auth_onboarding_3_subtitle".localized,
                image: UIImage.Icons.bigPeopleGroups
            )
        ]
    }
    
    func welcome() -> AuthUIModel.Onboarding {
        .init(
            title: "auth_welcome_title".localized,
            subtitle: "auth_welcome_subtitle".localized,
            image: UIImage.Icons.bigResume
        )
    }
    
    func genders() -> [SelectableListItemView.Model] {
        [
            .init(
                id: 1,
                title: "auth_gender_female".localized,
                type: AuthUIModel.Gender.female.rawValue,
                selected: false
            ),
            .init(
                id: 2,
                title: "auth_gender_male".localized,
                type: AuthUIModel.Gender.male.rawValue,
                selected: false
            )
        ]
    }
    
    func interests() async throws(APIError) -> [AuthUIModel.Interests] {
        try await repo.getCategories()
    }
    
    func login(
        communityId: Int,
        email: String,
        password: String?,
        idToken: String?
    ) async throws(APIError) -> Bool {
        try await repo.login(
            communityId: communityId,
            email: email,
            password: password,
            idToken: idToken
        )
    }
    
    @MainActor
    func getCommunities() async throws(APIError) -> [SelectableListItemView.Model] {
        try await repo.getCommunityList()
    }
    
    func sendOptionals(
        multiPart: MultipartFormData?,
        queryData: AuthDTOModel.OptionalsQuery?
    ) async throws(APIError) -> Data {
        try await repo.sendOptionals(
            multiPart: multiPart,
            queryData: queryData
        )
    }
    
    func getLanguages() async throws(APIError) -> [SelectableListItemView.Model] {
        try  await repo.getLanguages()
    }
}
