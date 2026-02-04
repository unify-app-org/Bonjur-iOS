//
//  UserCardModel.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 04.02.26.
//

import Foundation
import AppUIKit

struct UserCardModel {
    let backgroundCover: AppUIEntities.BackgroundType?
    let nameSurname: String
    let speciality: String
    let course: String
    let community: String
    let degree: String
    let entryYear: String
    let email: String
    let imageUrl: URL?
}

extension UserCardModel {
    static let mock: [Self] = [
        .init(
            backgroundCover: .primary,
            nameSurname: "Huseyn Hasanov",
            speciality: "Oil-gas engineering",
            course: "1st year",
            community: "UFAZ",
            degree: "Master",
            entryYear: "2025",
            email: "h.hasanov@gmail.com",
            imageUrl: nil
        ),
        .init(
            backgroundCover: nil,
            nameSurname: "Huseyn Hasanov",
            speciality: "Oil-gas engineering",
            course: "1st year",
            community: "UFAZ",
            degree: "Master",
            entryYear: "2025",
            email: "h.hasanov@gmail.com",
            imageUrl: nil
        ),
        .init(
            backgroundCover: .secondary,
            nameSurname: "Huseyn Hasanov",
            speciality: "Oil-gas engineering",
            course: "1st year",
            community: "UFAZ",
            degree: "Master",
            entryYear: "2025",
            email: "h.hasanov@gmail.com",
            imageUrl: nil
        )
    ]
}
