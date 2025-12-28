//
//  AuthUsecases.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 25.11.25.
//

import AppNetwork
import UIKit
import AppUIKit

protocol AuthUsecases {
    func register(
        body: RegisterRequest
    ) async throws(APIError) -> RegisterModel
    
    func onboarding() -> [OnboardingUIModel]
    
    func chooseUniversity() async throws(APIError) -> [ChooseUniversityUIModel]
    
    func welcome(name: String) -> OnboardingUIModel
    
    func languages() -> [SelectableListItemView.Model]
    
    func genders() -> [SelectableListItemView.Model]
}

final class AuthUsecasesImpl: AuthUsecases {
    
    private let dataSource: AuthDataSource
    
    init(dataSource: AuthDataSource = resolve()) {
        self.dataSource = dataSource
    }
    
    func register(
        body: RegisterRequest
    ) async throws(APIError) -> RegisterModel {
        let data = try await dataSource.register(body: body)
        return RegisterModel(
            token: data.token,
            refreshToken: data.refreshToken
        )
    }
    
    func onboarding() -> [OnboardingUIModel] {
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
    
    func chooseUniversity() async throws(APIError) -> [ChooseUniversityUIModel] {
        return [
            .init(
                title: "UFAZ",
                selected: false
            ),
            .init(
                title: "ADNSU",
                selected: false
            ),
            .init(
                title: "BHOS",
                selected: false
            )
        ]
    }
    
    func welcome(
        name: String
    ) -> OnboardingUIModel {
        .init(
            title: "Welcome \(name)",
            subtitle: "Complete your profile for better interaction.It will take only 5 minutes.",
            image: UIImage.Icons.bigResume
        )
    }
    
    func languages() -> [SelectableListItemView.Model] {
        [
            .init(
                title: "Azerbaijan",
                selected: false,
                style: .multySelect
            ),
            .init(
                title: "English",
                selected: false,
                style: .multySelect
            ),
            .init(
                title: "Russian",
                selected: false,
                style: .multySelect
            ),
            .init(
                title: "French",
                selected: false,
                style: .multySelect
            ),
            .init(
                title: "Turkish",
                selected: false,
                style: .multySelect
            )
        ]
    }
    
    func genders() -> [SelectableListItemView.Model] {
        [
            .init(
                title: "Female",
                selected: false
            ),
            .init(
                title: "Male",
                selected: false
            )
        ]
    }
}
