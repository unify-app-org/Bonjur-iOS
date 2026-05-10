//
//  AuthUsecases.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 25.11.25.
//

import AppNetwork
import UIKit
import AppUIKit
import AppStorage

protocol AuthUsecases {
    
    func onboarding() -> [AuthUIModel.Onboarding]
        
    func welcome(name: String) -> AuthUIModel.Onboarding
    
    func languages() -> [SelectableListItemView.Model]
    
    func genders() -> [SelectableListItemView.Model]
    
    func interests() -> [AuthUIModel.Interests]
    
    func login(
        communityId: Int,
        email: String,
        password: String?
    ) async throws(APIError)
    
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
                title: "Find Your \nPeople",
                subtitle: "Join your university community and start connecting with like-minded friends.",
                image: UIImage.Icons.bigGraduationHat
            ),
            .init(
                title: "Chat Your \nWay",
                subtitle: "Send messages and share idea instantly, all through your favorite apps.",
                image: UIImage.Icons.bigLamps
            ),
            .init(
                title: "Make It \nYours",
                subtitle: "Customize your app style and enjoy conversations your way.",
                image: UIImage.Icons.bigPeopleGroups
            )
        ]
    }
    
    func welcome(
        name: String
    ) -> AuthUIModel.Onboarding {
        .init(
            title: "Welcome \(name)",
            subtitle: "Complete your profile for better interaction.It will take only 5 minutes.",
            image: UIImage.Icons.bigResume
        )
    }
    
    func languages() -> [SelectableListItemView.Model] {
        []
    }
    
    func genders() -> [SelectableListItemView.Model] {
        [
            .init(
                id: 1,
                title: "Female",
                type: AuthUIModel.Gender.female.rawValue,
                selected: false
            ),
            .init(
                id: 2,
                title: "Male",
                type: AuthUIModel.Gender.male.rawValue,
                selected: false
            )
        ]
    }
    
    func interests() -> [AuthUIModel.Interests] {
        return []
    }
    
    func login(
        communityId: Int,
        email: String,
        password: String?
    ) async throws(APIError) {
        try await repo.login(
            communityId: communityId,
            email: email,
            password: password
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
