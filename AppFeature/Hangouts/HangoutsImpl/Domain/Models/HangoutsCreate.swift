//
//  HangoutsCreate.swift
//  AppFeature
//
//  Created by Codex on 30.05.26.
//

import Foundation
import AppUIKit
import AppPresentationModel

enum HangoutsCreate {

    typealias FieldID = AppUIKit.AppFieldSchema.FieldID
    typealias FieldValue = AppUIKit.AppFieldSchema.FieldValue
    typealias FieldType = AppUIKit.AppFieldSchema.FieldType
    typealias FieldSchema = AppUIKit.AppFieldSchema.Field
    typealias RadioOption = AppUIKit.AppFieldSchema.RadioOption
    typealias TagItem = AppUIKit.AppFieldSchema.TagItem
    typealias LinkItem = AppUIKit.AppFieldSchema.LinkItem

    struct PrefillData {
        let visibility: AppPresentationModel.AccessType
        let name: String
        let ownerContact: String
        let clubName: String
        let clubOwnerContact: String
        let categories: [TagItem]
        let capacity: String
        let links: [LinkItem]
        let rules: String
        let location: String
        let about: String
        let hangoutDate: Date?
        let endDate: Date?
        let values: [FieldID: FieldValue]

        init(
            visibility: AppPresentationModel.AccessType,
            name: String,
            ownerContact: String,
            clubName: String,
            clubOwnerContact: String,
            categories: [TagItem],
            capacity: String,
            links: [LinkItem],
            rules: String,
            location: String,
            about: String,
            hangoutDate: Date?,
            endDate: Date?
        ) {
            self.visibility = visibility
            self.name = name
            self.ownerContact = ownerContact
            self.clubName = clubName
            self.clubOwnerContact = clubOwnerContact
            self.categories = categories
            self.capacity = capacity
            self.links = links
            self.rules = rules
            self.location = location
            self.about = about
            self.hangoutDate = hangoutDate
            self.endDate = endDate
            self.values = [
                .visibility: .radio(visibility),
                .hangoutName: .text(name),
                .ownerContact: .text(ownerContact),
                .category: .tags(categories),
                .capacity: .text(capacity),
                .links: .links(links),
                .location: .text(location),
                .hangoutDate: .date(hangoutDate ?? Date()),
                .rules: .text(rules),
                .about: .text(about)
            ]
        }
    }
}
