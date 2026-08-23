//
//  HangoutsDataSource.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 22.01.26.
//

import Foundation
import AppFoundation
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
        size: Int,
        keyword: String?
    ) async throws(APIError) -> PageNationResponse<[HangoutsDTOModel.MemberResponse]>

    func exitHangout(id: String) async throws(APIError) -> Data
    func deleteHangout(id: String) async throws(APIError) -> Data
    func joinHangout(request: HangoutsDTOModel.JoinRequest) async throws(APIError) -> Data
}

final class HangoutsDataSourceImpl: NetworkService<HangoutsEndPoint>, HangoutsDataSource {

    func fetchHangouts(
        query: [String: String]
    ) async throws(APIError) -> [HangoutsDTOModel.Hangout] {
        try await fetch(endPoint: .getHangouts(query))
    }

    /// Declarative hangout-create form.
    ///
    /// Same canonical field order and `required` flags as the club and event forms —
    /// what → when → where → how many → describe → extras → contact. `visibility`
    /// is the fixed top block and stays first.
    func fetchCreate() async throws(APIError) -> [HangoutsCreate.FieldSchema] {
        [
            // MARK: Top block (fixed)
            HangoutsCreate.FieldSchema(
                id: .visibility,
                label: "hangouts_visibility_q".localized,
                type: .radioGroup(options: [
                    HangoutsCreate.RadioOption(
                        value: .public,
                        label: "hangouts_public".localized,
                        description: "hangouts_public_desc".localized
                    ),
                    HangoutsCreate.RadioOption(
                        value: .private,
                        label: "hangouts_private".localized,
                        description: "hangouts_private_desc".localized
                    )
                ])
            ),
            // MARK: Body (canonical order)
            HangoutsCreate.FieldSchema(
                id: .hangoutName,
                label: "hangouts_name_label".localized,
                type: .text(placeholder: "hangouts_name_ph".localized),
                hint: "hangouts_name_locked_hint".localized
            ),
            HangoutsCreate.FieldSchema(
                id: .category,
                label: "hangouts_category_label".localized,
                type: .chipInput(placeholder: "hangouts_add_category".localized)
            ),
            HangoutsCreate.FieldSchema(
                id: .hangoutDate,
                label: "hangouts_start_date".localized,
                type: .date(placeholder: "dd/mm/yyyy")
            ),
            HangoutsCreate.FieldSchema(
                id: .location,
                label: "hangouts_location_label".localized,
                type: .text(placeholder: "hangouts_location_ph".localized)
            ),
            HangoutsCreate.FieldSchema(
                id: .capacity,
                label: "hangouts_capacity_label".localized,
                type: .text(placeholder: "200", keyboardType: .numberPad),
                required: false
            ),
            HangoutsCreate.FieldSchema(
                id: .about,
                label: "hangouts_about_label".localized,
                type: .textArea(placeholder: "", maxLength: 500)
            ),
            HangoutsCreate.FieldSchema(
                id: .rules,
                label: "hangouts_rules_label".localized,
                type: .textArea(placeholder: "", maxLength: 500)
            ),
            HangoutsCreate.FieldSchema(
                id: .links,
                label: "hangouts_add_link".localized,
                type: .linkInput(placeholder: "hangouts_add_link".localized),
                required: false
            ),
            HangoutsCreate.FieldSchema(
                id: .ownerContact,
                label: "hangouts_owner_contact_label".localized,
                type: .text(placeholder: "hangouts_owner_contact_ph".localized)
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
        size: Int,
        keyword: String?
    ) async throws(APIError) -> PageNationResponse<[HangoutsDTOModel.MemberResponse]> {
        var query = ["page": "\(page)", "size": "\(size)"]
        if let keyword, !keyword.isEmpty { query["keyword"] = keyword }
        return try await fetch(
            endPoint: .members(id, query)
        )
    }

    func joinHangout(request: HangoutsDTOModel.JoinRequest) async throws(APIError) -> Data {
        try await fetchRawData(endPoint: .joinHangout(request))
    }

    func exitHangout(id: String) async throws(APIError) -> Data {
        try await fetchRawData(endPoint: .exitHangout(id))
    }

    func deleteHangout(id: String) async throws(APIError) -> Data {
        try await fetchRawData(endPoint: .deleteHangout(id))
    }
}
