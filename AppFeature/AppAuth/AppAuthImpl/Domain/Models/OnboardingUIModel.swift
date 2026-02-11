//
//  OnboardingUIModel.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 26.12.25.
//

import UIKit

struct OnboardingUIModel: Identifiable {
    let id: UUID = UUID()
    let title: String
    let subtitle: String
    let image: UIImage
    
    static let mockData: OnboardingUIModel = OnboardingUIModel(
            title: "Find Your \nPeople",
            subtitle: "Join your university community and start connecting with like-minded friends.",
            image: UIImage.Icons.bigGraduationHat
        )
}
