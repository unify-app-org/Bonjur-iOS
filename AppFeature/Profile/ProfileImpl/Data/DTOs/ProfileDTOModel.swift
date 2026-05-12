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

    // MARK: - Response
    
    struct Response: Decodable {
        let fullName, mail, phone, faculty: String?
        let specialization, username, about, degree, profileUrl: String?
        let background: AppPresentationModel.BackgroundType?
        let entryYear, year: Int?
        let gender, birthDate: String?
        let categories: [Category]?
        let languages: [Language]?
        
        struct Category: Decodable {
            let id: Int?
            let title: String?
        }
        
        struct Language: Decodable {
            let id: Int?
            let name: String?
        }
    }
}
