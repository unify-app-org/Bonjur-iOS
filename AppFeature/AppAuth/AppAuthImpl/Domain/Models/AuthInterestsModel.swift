//
//  AuthInterestsModel.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 30.12.25.
//

import Foundation
import AppUIKit

struct AuthInterestsModel: Identifiable {
    let id: UUID = UUID()
    let title: String
    let interests: [CategorieChipsView.Model]
}
