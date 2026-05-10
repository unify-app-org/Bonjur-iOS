//
//  ProfileDTOModel.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 11.05.26.
//

import Foundation

struct ProfileDTOModel {
    
    //MARK: - Request
    
    struct UpdateRequest: Encodable {
        let birthDate: String?
        let gender: String?
        let about: String?
        let categoriesId: [Int]
        let languagesId: [Int]
    }
    
    // MARK: - Response
    
    struct Response: Decodable {
        let fullName, mail, phone, faculty: String?
        let specialization, username, about, degree: String?
        let entryYear, year: Int?
        let gender, birthDate: String?
        let categories: [Category]?
        let languages: [Language]?
        
        struct Category: Codable {
            let id: Int?
            let title: String?
        }
        
        struct Language: Codable {
            let id: Int?
            let name: String?
        }
    }
}
