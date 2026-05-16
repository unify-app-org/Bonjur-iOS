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
    func fetchClubMemberById(id: Int) async throws(APIError) -> CommunityDTO.MemberResponse
}

final class CommunityDataSourceImpl: NetworkService<CommunityEndPoint>, CommunityDataSource {
    func fetchClubById(
        id: Int
    ) async throws(AppNetwork.APIError) -> CommunityDTO.Response {
        try await fetch(endPoint: .getClubById(id))
    }
    
    func fetchClubMemberById(
        id: Int
    ) async throws(AppNetwork.APIError) -> CommunityDTO.MemberResponse {
        try await fetch(endPoint: .getMembersByClubId(id))
    }
}
