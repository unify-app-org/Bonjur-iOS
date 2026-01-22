//
//  EventsUseCase.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 22.01.26.
//

import AppUIKit
import AppNetwork

protocol EventsUseCase {
    func fetchEvenets() async throws(APIError) -> [EventsCardView.Model]
}

class EventsUseCaseImpl: EventsUseCase {
    
    private let dataSource: EventsDataSource
    
    init(dataSource: EventsDataSource = resolve()) {
        self.dataSource = dataSource
    }

    func fetchEvenets() async throws(APIError) -> [EventsCardView.Model] {
        EventsCardView.Model.previewMock
    }
}
