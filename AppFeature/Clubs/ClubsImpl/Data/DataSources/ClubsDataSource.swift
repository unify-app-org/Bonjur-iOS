//
//  ClubsDataSource.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 20.01.26.
//

import Foundation
import AppNetwork

protocol ClubsDataSource {
    func fetchCreate() async throws(APIError) -> [ClubsCreate.FieldSchema]
}

final class ClubsDataSourceImpl: NetworkService<ClubsEndPoint>, ClubsDataSource {
    
    func fetchCreate() async throws(APIError) -> [ClubsCreate.FieldSchema] {
        [
            ClubsCreate.FieldSchema(
                id: .cover,
                label: "Choose a cover style for your club card",
                type: .coverPicker(item: .init(
                    title: "Choose a cover style for your club",
                    description: "If you don’t upload a cover image, the selected color will be used as your club cover.",
                    covers: [
                        .primary,
                        .secondary,
                        .teritary,
                        .color(.orange),
                        .color(.red),
                        .color(.pink)
                    ])
                )
            ),
            ClubsCreate.FieldSchema(
                id: .visibility,
                label: "Who can see your club?",
                type: .radioGroup(options: [
                    ClubsCreate.RadioOption(
                        value: .public,
                        label: "Public",
                        description: "This is a Public Club. Feel free to use the contact details below to get in touch with the organizers."
                    ),
                    ClubsCreate.RadioOption(
                        value: .private,
                        label: "Private",
                        description: "Contact details and group links are only visible to members. Join the club to access this information."
                    )
                ])
            ),
            ClubsCreate.FieldSchema(
                id: .clubName,
                label: "Club name",
                type: .text(placeholder: "Futbool Club")
            ),
            ClubsCreate.FieldSchema(
                id: .ownerContact,
                label: "Owner contact",
                type: .text(placeholder: "+994 123 45 67")
            ),
            ClubsCreate.FieldSchema(
                id: .category,
                label: "Category",
                type: .chipInput(placeholder: "Add category")
            ),
            ClubsCreate.FieldSchema(
                id: .capacity,
                label: "Capasity",
                type: .text(placeholder: "200"),
                required: false
            ),
            ClubsCreate.FieldSchema(
                id: .links,
                label: "Add link",
                type: .linkInput(placeholder: "Add link"),
                required: false
            ),
            ClubsCreate.FieldSchema(
                id: .location,
                label: "Location",
                type: .text(placeholder: "200")
            ),
            ClubsCreate.FieldSchema(
                id: .rules,
                label: "Rules",
                type: .textArea(placeholder: "Everyone can some",maxLength: 100)
            ),
            ClubsCreate.FieldSchema(
                id: .about,
                label: "About",
                type: .textArea(placeholder: "I want to have a coffee and then go...", maxLength: 100)
            )
        ]
    }
}
