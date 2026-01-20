//
//  ClubsUseCase.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 20.01.26.
//

import AppUIKit
import AppNetwork

protocol ClubsUseCase {
    func fetchClubsData() async throws(APIError) -> [ClubCardView.Model]
}

class ClubsUseCaseImpl: ClubsUseCase {
    
    private let dataSource: ClubsDataSource
    
    init(dataSource: ClubsDataSource = resolve()) {
        self.dataSource = dataSource
    }

    func fetchClubsData() async throws(APIError) -> [ClubCardView.Model] {
        ClubCardView.Model.previewData
    }
}
