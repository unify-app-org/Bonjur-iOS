//
//  ProfileUseCase.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 04.02.26.
//

import Foundation
import AppNetwork

protocol ProfileUseCase {
    func getProfileData() async throws(APIError) -> ProfileDetail.UIModel
}

class ProfileUseCaseImpl: ProfileUseCase {
    
    private let dataSource: ProfileDataSource
    
    init(dataSource: ProfileDataSource = resolve()) {
        self.dataSource = dataSource
    }
    
    func getProfileData() async throws(APIError) -> ProfileDetail.UIModel {
        .mock
    }
}
