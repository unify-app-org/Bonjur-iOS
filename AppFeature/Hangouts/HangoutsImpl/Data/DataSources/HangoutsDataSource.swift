//
//  HangoutsDataSource.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 22.01.26.
//

import Foundation
import AppNetwork
import AppUIKit
import UIKit

protocol HangoutsDataSource {
    func fetchHangouts(
        query: [String: String]
    ) async throws(APIError) -> [HangoutsDTOModel.Hangout]

    func fetchCreate() async throws(APIError) -> [HangoutsCreate.FieldSchema]

    func createHangout(
        request: HangoutsDTOModel.Request
    ) async throws(APIError) -> Data

    func editHangout(
        id: String,
        request: HangoutsDTOModel.Request
    ) async throws(APIError) -> Data

    func getCategories() async throws(APIError) -> [HangoutsDTOModel.CategoriesResponse]

    func fetchHangoutsDetail(
        id: String
    ) async throws(APIError) -> HangoutsDTOModel.HangoutDetail

    func fetchMembers(
        id: String,
        page: Int,
        size: Int
    ) async throws(APIError) -> PageNationResponse<[HangoutsDTOModel.MemberResponse]>

    func exitHangout(id: String) async throws(APIError) -> Data
}

final class HangoutsDataSourceImpl: NetworkService<HangoutsEndPoint>, HangoutsDataSource {

    func fetchHangouts(
        query: [String: String]
    ) async throws(APIError) -> [HangoutsDTOModel.Hangout] {
        try await fetch(endPoint: .getHangouts(query))
    }

    func fetchCreate() async throws(APIError) -> [HangoutsCreate.FieldSchema] {
        [
            HangoutsCreate.FieldSchema(
                id: .visibility,
                label: "Who can see your hangout?",
                type: .radioGroup(options: [
                    HangoutsCreate.RadioOption(
                        value: .public,
                        label: "Public",
                        description: "This is a Public Hangout. Feel free to use the contact details below to get in touch with the organizers."
                    ),
                    HangoutsCreate.RadioOption(
                        value: .private,
                        label: "Private",
                        description: "Contact details and group links are only visible to members. Join the hangout to access this information."
                    )
                ])
            ),
            HangoutsCreate.FieldSchema(
                id: .hangoutName,
                label: "Hangout name",
                type: .text(placeholder: "Study night at cafe")
            ),
            HangoutsCreate.FieldSchema(
                id: .ownerContact,
                label: "Owner contact",
                type: .text(placeholder: "+994 123 45 67")
            ),
            HangoutsCreate.FieldSchema(
                id: .category,
                label: "Category",
                type: .chipInput(placeholder: "Add category")
            ),
            HangoutsCreate.FieldSchema(
                id: .links,
                label: "Add link",
                type: .linkInput(placeholder: "Add link"),
                required: false
            ),
            HangoutsCreate.FieldSchema(
                id: .capacity,
                label: "Capacity",
                type: .text(placeholder: "200", keyboardType: .numberPad),
                required: false
            ),
            HangoutsCreate.FieldSchema(
                id: .location,
                label: "Location",
                type: .text(placeholder: "Library")
            ),
            HangoutsCreate.FieldSchema(
                id: .hangoutDate,
                label: "Start date",
                type: .date(placeholder: "dd/mm/yyyy")
            ),
            HangoutsCreate.FieldSchema(
                id: .rules,
                label: "Rules",
                type: .textArea(placeholder: "", maxLength: 500)
            ),
            HangoutsCreate.FieldSchema(
                id: .about,
                label: "About",
                type: .textArea(placeholder: "", maxLength: 500)
            )
        ]
    }

    func createHangout(
        request: HangoutsDTOModel.Request
    ) async throws(APIError) -> Data {
        try await fetchRawData(endPoint: .createHangout(request))
    }

    func editHangout(
        id: String,
        request: HangoutsDTOModel.Request
    ) async throws(APIError) -> Data {
        try await fetchRawData(endPoint: .editHangout(id, request))
    }

    func getCategories() async throws(APIError) -> [HangoutsDTOModel.CategoriesResponse] {
        try await fetch(endPoint: .getCategories)
    }

    func fetchHangoutsDetail(
        id: String
    ) async throws(APIError) -> HangoutsDTOModel.HangoutDetail {
        try await fetch(endPoint: .hangoutDetail(id))
    }

    func fetchMembers(
        id: String,
        page: Int,
        size: Int
    ) async throws(APIError) -> PageNationResponse<[HangoutsDTOModel.MemberResponse]> {
        try await fetch(
            endPoint: .members(id, ["page": "\(page)", "size": "\(size)"])
        )
    }

    func exitHangout(id: String) async throws(APIError) -> Data {
        try await fetchRawData(endPoint: .exitHangout(id))
    }
}
