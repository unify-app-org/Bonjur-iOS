//
//  ClubsDataSource.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 20.01.26.
//

import Foundation
import AppFoundation
import AppNetwork

protocol ClubsDataSource {
    func fetchCreate() async throws(APIError) -> [ClubsCreate.FieldSchema]
    func getCategories() async throws(APIError) -> [ClubsCreate.CategoriesResponse]
    func fetchClubs(query: [String: String]) async throws(APIError) -> [ClubDTOModel.ListResponse]
    func createClub(request: MultipartFormData) async throws(APIError) -> Data
    func fetchClubById(id: Int) async throws(APIError) -> ClubDTOModel.Response
    func fetchClubMemberById(id: Int, page: Int, size: Int, keyword: String?) async throws(APIError) -> ClubDTOModel.MemberResponse
    func editClub(id: Int, request: MultipartFormData) async throws(APIError) -> Data
    func joinClub(id: Int) async throws(APIError) -> Data
    func assignRole(id: Int, request: ClubDTOModel.RoleAssignRequest) async throws(APIError) -> Data
    func exitClub(id: Int) async throws(APIError) -> Data
    func requestVerify(id: Int) async throws(APIError) -> Data
}

final class ClubsDataSourceImpl: NetworkService<ClubsEndPoint>, ClubsDataSource {

    func getCategories() async throws(APIError) -> [ClubsCreate.CategoriesResponse] {
        try await fetch(endPoint: .getCategories)
    }

    func fetchClubs(query: [String: String]) async throws(APIError) -> [ClubDTOModel.ListResponse] {
        try await fetch(endPoint: .getClubs(query))
    }

    /// Declarative club-create form.
    ///
    /// Field order and `required` flags are the canonical spine shared by all three
    /// create forms (club / event / hangout) on both platforms — see the Android
    /// `ClubCreateSchema`. Body order is: what → when → where → how many →
    /// describe → extras → contact. Everything above `clubName` (cover, visibility)
    /// is the fixed top block and is deliberately not part of that reordering.
    func fetchCreate() async throws(APIError) -> [ClubsCreate.FieldSchema] {
        [
            // MARK: Top block (fixed)
            ClubsCreate.FieldSchema(
                id: .cover,
                label: "clubs_cover_card_label".localized,
                type: .coverPicker(item: .init(
                    title: "clubs_cover_title".localized,
                    description: "clubs_cover_desc".localized,
                    covers: [
                        .primary,
                        .secondary,
                        .teritary,
                        .orange,
                        .red,
                        .pink
                    ])
                ),
                required: false
            ),
            ClubsCreate.FieldSchema(
                id: .visibility,
                label: "clubs_visibility_q".localized,
                type: .radioGroup(options: [
                    ClubsCreate.RadioOption(
                        value: .public,
                        label: "clubs_public".localized,
                        description: "clubs_public_desc".localized
                    ),
                    ClubsCreate.RadioOption(
                        value: .private,
                        label: "clubs_private".localized,
                        description: "clubs_private_desc".localized
                    )
                ])
            ),
            // MARK: Body (canonical order)
            ClubsCreate.FieldSchema(
                id: .clubName,
                label: "clubs_name_label".localized,
                type: .text(placeholder: "clubs_name_ph".localized),
                hint: "clubs_name_locked_hint".localized
            ),
            ClubsCreate.FieldSchema(
                id: .category,
                label: "clubs_category_label".localized,
                type: .chipInput(placeholder: "clubs_add_category".localized)
            ),
            ClubsCreate.FieldSchema(
                id: .location,
                label: "clubs_location_label".localized,
                type: .text(placeholder: "clubs_location_ph".localized)
            ),
            ClubsCreate.FieldSchema(
                id: .capacity,
                label: "clubs_capacity_label".localized,
                type: .text(placeholder: "200", keyboardType: .numberPad),
                required: false
            ),
            ClubsCreate.FieldSchema(
                id: .about,
                label: "clubs_about_label".localized,
                type: .textArea(placeholder: "clubs_about_ph".localized, maxLength: 500)
            ),
            ClubsCreate.FieldSchema(
                id: .rules,
                label: "clubs_rules_label".localized,
                type: .textArea(placeholder: "clubs_rules_ph".localized, maxLength: 500)
            ),
            ClubsCreate.FieldSchema(
                id: .links,
                label: "clubs_add_link".localized,
                type: .linkInput(placeholder: "clubs_add_link".localized),
                required: false
            ),
            ClubsCreate.FieldSchema(
                id: .ownerContact,
                label: "clubs_owner_contact_label".localized,
                type: .text(placeholder: "clubs_owner_contact_ph".localized)
            )
        ]
    }
    
    func editClub(
        id: Int,
        request: MultipartFormData
    ) async throws(APIError) -> Data {
        try await fetchRawData(endPoint: .editClub(id, request))
    }
    
    func createClub(request: MultipartFormData) async throws(APIError) -> Data {
        try await fetchRawData(endPoint: .createClub(request))
    }
    
    func fetchClubById(id: Int) async throws(APIError) -> ClubDTOModel.Response {
        try await fetch(endPoint: .getClubById(id))
    }
    
    func fetchClubMemberById(id: Int, page: Int, size: Int, keyword: String?) async throws(APIError) -> ClubDTOModel.MemberResponse {
        var query = ["page": "\(page)", "size": "\(size)"]
        if let keyword, !keyword.isEmpty { query["keyword"] = keyword }
        return try await fetch(
            endPoint: .getMembersByClubId(id, query)
        )
    }
    
    func joinClub(id: Int) async throws(APIError) -> Data {
        try await fetchRawData(endPoint: .joinClub(id))
    }

    func assignRole(
        id: Int,
        request: ClubDTOModel.RoleAssignRequest
    ) async throws(APIError) -> Data {
        try await fetchRawData(endPoint: .assignRole(id, request))
    }

    func exitClub(id: Int) async throws(APIError) -> Data {
        try await fetchRawData(endPoint: .exitClub(id))
    }

    func requestVerify(id: Int) async throws(APIError) -> Data {
        try await fetchRawData(endPoint: .requestVerify(id))
    }
}
