//
//  EventsUseCase.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 22.01.26.
//

import AppUIKit
import AppNetwork

protocol EventsUseCase {
    func fetchEvents() async throws(APIError) -> [EventsCardView.Model]
    func fetchEventDetail(eventId: String) async throws(APIError) -> EventsDetailsModel.UIModel
}

class EventsUseCaseImpl: EventsUseCase {
    
    private let dataSource: EventsDataSource
    
    init(dataSource: EventsDataSource = resolve()) {
        self.dataSource = dataSource
    }

    func fetchEvents() async throws(APIError) -> [EventsCardView.Model] {
        EventsCardView.Model.previewMock
    }
    
    func fetchEventDetail(
        eventId: String
    ) async throws(APIError) -> EventsDetailsModel.UIModel {
        EventsDetailsModel.UIModel.mockData
    }
}
