//
//  ChooseUniversityUIModel.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 26.12.25.
//

import Foundation

struct ChooseUniversityUIModel: Identifiable {
    let id: UUID = UUID()
    let title: String
    var selected: Bool
}
