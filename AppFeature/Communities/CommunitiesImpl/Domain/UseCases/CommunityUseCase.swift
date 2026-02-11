//
//  CommunityUseCase.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 03.02.26.
//

import Foundation

protocol CommunityUseCase {
    func fetchCommunityData(id: Int) async throws -> CommunityDetails.UIModel
}

class CommunityUseCaseImpl: CommunityUseCase {
    
    private let dataSource: CommunityDataSource
    
    init(dataSource: CommunityDataSource = resolve()) {
        self.dataSource = dataSource
    }
    
    func fetchCommunityData(id: Int) async throws -> CommunityDetails.UIModel {
        CommunityDetails.UIModel.mockData
    }
}
