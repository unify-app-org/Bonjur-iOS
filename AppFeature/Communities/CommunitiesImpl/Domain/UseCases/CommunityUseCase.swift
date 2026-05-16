//
//  CommunityUseCase.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 03.02.26.
//

import Foundation
import Communities

protocol CommunityUseCase {
    func fetchCommunityData(id: Int) async throws -> CommunityDetails.UIModel
    func fetchCommunityMembers(id: Int) async throws -> CommunitiesMemberModuleModel.GroupedMembersData
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
}
