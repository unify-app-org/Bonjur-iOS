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
    
    @MainActor
    func getCommunities() async throws(APIError) -> [SelectableListItemView.Model]
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
        [
            .init(
                id: 1,
                title: "Azerbaijan",
                selected: false,
                style: .multySelect
            ),
            .init(
                id: 2,
                title: "English",
                selected: false,
                style: .multySelect
            ),
            .init(
                id: 3,
                title: "Russian",
                selected: false,
                style: .multySelect
            ),
            .init(
                id: 4,
                title: "French",
                selected: false,
                style: .multySelect
            ),
            .init(
                id: 5,
                title: "Turkish",
                selected: false,
                style: .multySelect
            )
        ]
    }
    
    func genders() -> [SelectableListItemView.Model] {
        [
            .init(
                id: 1,
                title: "Female",
                selected: false
            ),
            .init(
                id: 2,
                title: "Male",
                selected: false
            )
        ]
    }
    
    func interests() -> [AuthUIModel.Interests] {
        return [
            .init(
                title: "Example",
                interests: [
                    .init(
                        id: 1,
                        title: "love",
                        selected: false
                    ),
                    .init(
                        id: 2,
                        title: "love",
                        selected: false
                    ),
                    .init(
                        id: 3,
                        title: "beautiful",
                        selected: false
                    ),
                    .init(
                        id: 4,
                        title: "fashion",
                        selected: false
                    ),
                    .init(
                        id: 5,
                        title: "dog",
                        selected: false
                    ),
                    .init(
                        id: 6,
                        title: "art",
                        selected: false
                    ),
                ]
            ),
            .init(
                title: "Example",
                interests: [
                    .init(
                        id: 7,
                        title: "love",
                        selected: false
                    ),
                    .init(
                        id: 8,
                        title: "love",
                        selected: false
                    ),
                    .init(
                        id: 9,
                        title: "beautiful",
                        selected: false
                    ),
                    .init(
                        id: 10,
                        title: "fashion",
                        selected: false
                    ),
                    .init(
                        id: 11,
                        title: "dog",
                        selected: false
                    ),
                    .init(
                        id: 12,
                        title: "art",
                        selected: false
                    ),
                    .init(
                        id: 13,
                        title: "love",
                        selected: false
                    ),
                    .init(
                        id: 14,
                        title: "beautiful",
                        selected: false
                    ),
                    .init(
                        id: 15,
                        title: "fashion",
                        selected: false
                    ),
                    .init(
                        id: 16,
                        title: "dog",
                        selected: false
                    ),
                    .init(
                        id: 17,
                        title: "art",
                        selected: false
                    ),
                ]
            )
            
        ]
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
}
