//
//  CommunityUseCase.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 03.02.26.
//

import Foundation
import Communities
import AppNetwork
import Clubs
import AppPresentationModel

protocol CommunityUseCase {
    func fetchCommunityData(id: Int) async throws -> CommunityDetails.UIModel
    func fetchCommunityMembers(id: Int) async throws -> CommunitiesMemberModuleModel.GroupedMembersData
    func fetchCommunityMembersPage(
        id: Int,
        page: Int,
        size: Int
    ) async throws(APIError) -> CommunitiesMemberModuleModel.MembersPage
    func fetchClubs(
        communityId: Int,
        query: CommunityDTO.PaginationQuery
    ) async throws(APIError) -> [ClubsModuleModel.CardInputData]
    func assignRole(
        communityId: Int,
        userId: String,
        role: AppPresentationModel.UserActivityRole
    ) async throws(APIError)
}

class CommunityUseCaseImpl: CommunityUseCase {
    
    private let repo: CommunityRepo
    
    init(repo: CommunityRepo = resolve()) {
        self.repo = repo
    }
    
    func fetchCommunityData(id: Int) async throws -> CommunityDetails.UIModel {
        try await repo.fetchClubById(id: id)
    }

    func fetchCommunityMembers(id: Int) async throws -> CommunitiesMemberModuleModel.GroupedMembersData {
        try await repo.fetchClubMemberById(id: id)
    }
    
    func fetchClubs(
        communityId: Int,
        query: CommunityDTO.PaginationQuery
    ) async throws(APIError) -> [ClubsModuleModel.CardInputData] {
        try await repo.getClubs(
            communityId: communityId,
            query: query
        )
    }
    
    func fetchCommunityMembersPage(id: Int, page: Int, size: Int) async throws(APIError) -> CommunitiesMemberModuleModel.MembersPage {
        try await repo.fetchCommunityMembersPage(
            id: id,
            page: page,
            size: size
        )
    }

    func assignRole(
        communityId: Int,
        userId: String,
        role: AppPresentationModel.UserActivityRole
    ) async throws(APIError) {
        try await repo.assignRole(
            communityId: communityId,
            userId: userId,
            role: role
        )
    }
}
