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
    func fetchClubMemberById(id: Int, page: Int, size: Int) async throws(APIError) -> CommunityDTO.MemberResponse
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
        size: Int
    ) async throws(AppNetwork.APIError) -> CommunityDTO.MemberResponse {
        try await fetch(
            endPoint: .getMembersByClubId(id, ["page": "\(page)", "size": "\(size)"])
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
