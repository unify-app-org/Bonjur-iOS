//
//  ProfileDTOModel.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 11.05.26.
//

import Foundation
import AppPresentationModel

struct ProfileDTOModel {
    
    //MARK: - Request
    
    struct UpdateRequest: Encodable {
        let birthDate: String?
        let gender: String?
        let about: String?
        let categoriesId: [Int]
        let languagesId: [Int]
    }

    //MARK: - Statics

    struct CategoriesResponse: Decodable {
        let type, title: String?
        let subCategories: [SubCategoriesResponse]
    }

    struct SubCategoriesResponse: Decodable {
        let id: Int?
        let title: String?
    }
}
