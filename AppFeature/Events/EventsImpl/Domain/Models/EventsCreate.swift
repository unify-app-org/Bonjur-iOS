//
//  EventsCreate.swift
//  EventsImpl
//
//  Created by Codex on 08.06.26.
//

import Foundation
import AppUIKit
import AppPresentationModel

enum EventsCreate {

    typealias FieldID = AppUIKit.AppFieldSchema.FieldID
    typealias FieldValue = AppUIKit.AppFieldSchema.FieldValue
    typealias FieldType = AppUIKit.AppFieldSchema.FieldType
    typealias FieldSchema = AppUIKit.AppFieldSchema.Field
    typealias RadioOption = AppUIKit.AppFieldSchema.RadioOption
    typealias ReminderOption = AppUIKit.AppFieldSchema.ReminderOption
    typealias TagItem = AppUIKit.AppFieldSchema.TagItem

    /// A club the event can be created under (`GET api/cs/v1/clubs/forEvents`).
    struct SelectableClub: Identifiable, Equatable {
        let clubId: Int
        let clubName: String
        let profileURL: URL?

        var id: Int { clubId }
    }

    /// Prefill payload for edit mode. Mirrors `ClubsCreate.PrefillData`.
    struct PrefillData {
        let selectedClubId: Int
        let values: [FieldID: FieldValue]

        init(selectedClubId: Int, values: [FieldID: FieldValue]) {
            self.selectedClubId = selectedClubId
            self.values = values
        }
    }

    /// Declarative event-create form. Mirrors the Android `EventCreateSchema`.
    static var schema: [FieldSchema] {
        [
            FieldSchema(
                id: .visibility,
                label: "Visibility",
                type: .radioGroup(options: [
                    RadioOption(
                        value: .public,
                        label: "Public",
                        description: "Anyone in the community can find and join this event."
                    ),
                    RadioOption(
                        value: .private,
                        label: "Private",
                        description: "Only people you approve can join. Contact stays hidden."
                    )
                ]),
                required: false
            ),
            FieldSchema(
                id: .eventName,
                label: "Event name",
                type: .text(placeholder: "Enter event name"),
                required: true
            ),
            FieldSchema(
                id: .ownerContact,
                label: "Owner contact",
                type: .text(placeholder: "Enter owner contact"),
                required: false
            ),
            FieldSchema(
                id: .about,
                label: "About",
                type: .textArea(placeholder: "About", maxLength: 500),
                required: false
            ),
            FieldSchema(
                id: .category,
                label: "Category",
                type: .chipInput(placeholder: "Add category"),
                required: false
            ),
            FieldSchema(
                id: .location,
                label: "Location",
                type: .text(placeholder: "Enter location"),
                required: false
            ),
            FieldSchema(
                id: .eventDate,
                label: "Date",
                type: .date(placeholder: "Pick date & time"),
                required: true
            ),
            FieldSchema(
                id: .reminder,
                label: "Reminder",
                type: .reminder(placeholder: "None"),
                required: false
            ),
            FieldSchema(
                id: .capacity,
                label: "Capacity",
                type: .text(placeholder: "Enter capacity", keyboardType: .numberPad),
                required: false
            ),
            FieldSchema(
                id: .links,
                label: "Add link",
                type: .linkInput(placeholder: "Add link"),
                required: false
            ),
            FieldSchema(
                id: .attachment,
                label: "Attachment",
                type: .attachment(
                    placeholder: "Add",
                    description: "You can upload files up to 15 MB total for this event."
                ),
                required: false
            ),
            FieldSchema(
                id: .rules,
                label: "Rules",
                type: .textArea(placeholder: "Rules", maxLength: 500),
                required: false
            )
        ]
    }

    /// Assembled create payload. Reminder is the backend enum raw value (`NONE`, `AT_EVENT_TIME`, …).
    /// Attachments are files uploaded separately (multipart) — not part of this JSON.
    struct Request: Encodable {
        let clubId: Int
        let name: String
        let about: String
        let location: String
        let ownerContact: String
        let capacity: Int?
        let rules: String?
        let visibility: String
        let eventDate: Date
        let reminder: String
        let categoryIds: [Int]
        let links: [Link]

        struct Link: Encodable {
            let type: String
            let name: String
            let url: String
        }
    }
}
