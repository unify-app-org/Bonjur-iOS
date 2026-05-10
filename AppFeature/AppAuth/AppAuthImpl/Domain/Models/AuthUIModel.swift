//
//  AuthUIModel.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 08.05.26.
//

import UIKit
import AppUIKit

struct AuthUIModel {
    
    struct Onboarding: Identifiable {
        let id: UUID = UUID()
        let title: String
        let subtitle: String
        let image: UIImage
    }
    
    struct Interests: Identifiable {
        let id: UUID = UUID()
        let type: String
        let title: String
        var interests: [CategoriesChipsView.Model]
    }
    
    enum Gender: String {
        case male = "MALE"
        case female = "FEMALE"
    }
}
