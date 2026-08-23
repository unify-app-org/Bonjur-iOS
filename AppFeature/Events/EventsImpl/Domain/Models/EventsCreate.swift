//
//  EventsCreate.swift
//  EventsImpl
//
//  Created by Codex on 08.06.26.
//

import Foundation
import AppFoundation
import AppUIKit
import AppPresentationModel

enum EventsCreate {

    typealias FieldID = AppUIKit.AppFieldSchema.FieldID
    typealias FieldValue = AppUIKit.AppFieldSchema.FieldValue
    typealias FieldType = AppUIKit.AppFieldSchema.FieldType
    typealias FieldSchema = AppUIKit.AppFieldSchema.Field
    typealias RadioOption = AppUIKit.AppFieldSchema.RadioOption
    typealias ReminderOption = AppPresentationModel.ReminderOption
    typealias TagItem = AppUIKit.AppFieldSchema.TagItem

    /// A club the event can be created under (`GET api/cs/v1/clubs/forEvents`).
    struct SelectableClub: Identifiable, Equatable {
        let clubId: Int
        let clubName: String
        let profileURL: URL?
        let backgroundURL: URL?
        let role: AppPresentationModel.UserActivityRole
        let background: AppPresentationModel.BackgroundType

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
    ///
    /// Same canonical field order and `required` flags as the club and hangout forms —
    /// what → when → where → how many → describe → extras → contact. The club picker
    /// and `visibility` are the fixed top block (the picker lives in the view, above
    /// this schema).
    static var schema: [FieldSchema] {
        [
            // MARK: Top block (fixed)
            FieldSchema(
                id: .visibility,
                label: "events_visibility".localized,
                type: .radioGroup(options: [
                    RadioOption(
                        value: .public,
                        label: "events_public".localized,
                        description: "events_public_desc".localized
                    ),
                    RadioOption(
                        value: .private,
                        label: "events_private".localized,
                        description: "events_private_desc".localized
                    )
                ]),
                required: true
            ),
            // MARK: Body (canonical order)
            FieldSchema(
                id: .eventName,
                label: "events_name_label".localized,
                type: .text(placeholder: "events_name_ph".localized),
                required: true,
                hint: "events_name_locked_hint".localized
            ),
            FieldSchema(
                id: .category,
                label: "events_category_label".localized,
                type: .chipInput(placeholder: "events_add_category".localized),
                required: true
            ),
            FieldSchema(
                id: .eventDate,
                label: "events_date_label".localized,
                type: .date(placeholder: "events_pick_datetime".localized),
                required: true
            ),
            FieldSchema(
                id: .reminder,
                label: "events_reminder".localized,
                type: .reminder(
                    placeholder: "events_none".localized,
                    description: "events_reminder_desc".localized
                ),
                required: false
            ),
            FieldSchema(
                id: .location,
                label: "events_location_label".localized,
                type: .text(placeholder: "events_location_ph".localized),
                required: true
            ),
            FieldSchema(
                id: .capacity,
                label: "events_capacity_label".localized,
                type: .text(placeholder: "events_capacity_ph".localized, keyboardType: .numberPad),
                required: false
            ),
            FieldSchema(
                id: .about,
                label: "events_about_label".localized,
                type: .textArea(placeholder: "events_about_ph".localized, maxLength: 500),
                required: true
            ),
            FieldSchema(
                id: .rules,
                label: "events_rules_label".localized,
                type: .textArea(placeholder: "events_rules_ph".localized, maxLength: 500),
                required: true
            ),
            FieldSchema(
                id: .attachment,
                label: "events_attachment".localized,
                type: .attachment(
                    placeholder: "events_add".localized,
                    description: "events_attachment_hint".localized
                ),
                required: false
            ),
            FieldSchema(
                id: .links,
                label: "events_add_link".localized,
                type: .linkInput(placeholder: "events_add_link".localized),
                required: false
            ),
            FieldSchema(
                id: .ownerContact,
                label: "events_owner_contact_label".localized,
                type: .text(placeholder: "events_owner_contact_ph".localized),
                required: true
            )
        ]
    }
}
