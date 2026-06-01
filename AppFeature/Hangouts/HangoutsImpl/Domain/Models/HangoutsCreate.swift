//
//  HangoutsCreate.swift
//  AppFeature
//
//  Created by Codex on 30.05.26.
//

import Foundation
import AppUIKit

enum HangoutsCreate {

    typealias FieldID = AppUIKit.AppFieldSchema.FieldID
    typealias FieldValue = AppUIKit.AppFieldSchema.FieldValue
    typealias FieldType = AppUIKit.AppFieldSchema.FieldType
    typealias FieldSchema = AppUIKit.AppFieldSchema.Field
    typealias RadioOption = AppUIKit.AppFieldSchema.RadioOption
    typealias TagItem = AppUIKit.AppFieldSchema.TagItem
    typealias LinkItem = AppUIKit.AppFieldSchema.LinkItem

    struct PrefillData {
        let values: [FieldID: FieldValue]

        init(
            values: [FieldID: FieldValue]
        ) {
            self.values = values
        }
    }
}
