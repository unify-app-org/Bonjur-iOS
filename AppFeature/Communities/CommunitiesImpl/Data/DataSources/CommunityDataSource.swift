//
//  CommunityDataSource.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 03.02.26.
//

import Foundation
import AppNetwork

protocol CommunityDataSource {
    func fetchClubById(id: Int) async throws(APIError) -> CommunityDTO.Response
    func fetchClubMemberById(id: Int, page: Int, size: Int, keyword: String?) async throws(APIError) -> CommunityDTO.MemberResponse
    func getClubs(
        query: [String: String]
    ) async throws(APIError) -> [CommunityDTO.ClubResponse]
    func assignRole(id: Int, request: CommunityDTO.RoleAssignRequest) async throws(APIError) -> Data
}

final class CommunityDataSourceImpl: NetworkService<CommunityEndPoint>, CommunityDataSource {
    func fetchClubById(
        id: Int
    ) async throws(AppNetwork.APIError) -> CommunityDTO.Response {
        try await fetch(endPoint: .getClubById(id))
    }
    
    func fetchClubMemberById(
        id: Int,
        page: Int,
        size: Int,
        keyword: String?
    ) async throws(AppNetwork.APIError) -> CommunityDTO.MemberResponse {
        var query = ["page": "\(page)", "size": "\(size)"]
        if let keyword, !keyword.isEmpty { query["keyword"] = keyword }
        return try await fetch(
            endPoint: .getMembersByClubId(id, query)
        )
    }
    
    func getClubs(
        query: [String: String]
    ) async throws(APIError) -> [CommunityDTO.ClubResponse] {
        try await fetch(endPoint: .getClubs(query))
    }

    func assignRole(
        id: Int,
        request: CommunityDTO.RoleAssignRequest
    ) async throws(APIError) -> Data {
        try await fetchRawData(endPoint: .assignRole(id, request))
    }
}
