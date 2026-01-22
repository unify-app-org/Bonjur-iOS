//
//  HangoutsUseCase.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 22.01.26.
//

import AppUIKit
import AppNetwork

protocol HangoutsUseCase {
    func fetchHangouts() async throws(APIError) -> [HangoutsCardView.Model]
}

class HangoutsUseCaseImpl: HangoutsUseCase {
    
    private let dataSource: HangoutsDataSource
    
    init(dataSource: HangoutsDataSource = resolve()) {
        self.dataSource = dataSource
    }

    func fetchHangouts() async throws(APIError) -> [HangoutsCardView.Model] {
        HangoutsCardView.Model.previewMock
    }
}
