//
//  ClubsCreate.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 21.02.26.
//

import Foundation
import AppUIKit
import AppPresentationModel

enum ClubsCreate {

    typealias FieldID = AppUIKit.AppFieldSchema.FieldID
    typealias FieldValue = AppUIKit.AppFieldSchema.FieldValue
    typealias FieldType = AppUIKit.AppFieldSchema.FieldType
    typealias FieldSchema = AppUIKit.AppFieldSchema.Field
    typealias RadioOption = AppUIKit.AppFieldSchema.RadioOption
    typealias CoverItem = AppUIKit.AppFieldSchema.CoverItem
    typealias TagItem = AppUIKit.AppFieldSchema.TagItem
    typealias LinkItem = AppUIKit.AppFieldSchema.LinkItem

    struct CategoriesResponse: Decodable {
        let type, title: String?
        let subCategories: [SubCategoriesResponse]
    }

    struct SubCategoriesResponse: Decodable {
        let id: Int?
        let title: String?
    }

    struct PrefillData {
        let logoURL: URL?
        let coverURL: URL?
        let values: [FieldID: FieldValue]

        init(
            logoURL: URL?,
            coverURL: URL?,
            values: [FieldID: FieldValue]
        ) {
            self.logoURL = logoURL
            self.coverURL = coverURL
            self.values = values
        }
    }

}
