//
//  EventsUseCase.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 22.01.26.
//

import Foundation
import AppUIKit
import AppNetwork

protocol EventsUseCase {
    func fetchEvents() async throws(APIError) -> [EventsCardView.Model]
    func fetchEventDetail(eventId: String) async throws(APIError) -> EventsDetailsModel.UIModel
    func createEvent(request: EventsCreate.Request) async throws(APIError)
    func fetchClubsForEvents() async throws(APIError) -> [EventsCreate.SelectableClub]
    func getCategories() async throws(APIError) -> [SelectCategoryView.Section]
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

    func createEvent(request: EventsCreate.Request) async throws(APIError) {
        // TODO: wire to backend once the create-event endpoint exists.
    }

    func fetchClubsForEvents() async throws(APIError) -> [EventsCreate.SelectableClub] {
        let data = try await dataSource.fetchClubsForEvents()
        return data.map { dto in
            EventsCreate.SelectableClub(
                clubId: dto.clubId,
                clubName: dto.clubName ?? "",
                profileURL: dto.profileUrl.flatMap { URL(string: $0) }
            )
        }
    }

    func getCategories() async throws(APIError) -> [SelectCategoryView.Section] {
        let data = try await dataSource.getCategories()
        return data.map { item in
            let categories: [CategoriesChipsView.Model] = item.subCategories.map { sub in
                .init(id: sub.id ?? 0, title: sub.title ?? "", selected: false)
            }
            return .init(
                type: item.type ?? "",
                title: item.title ?? "",
                categories: categories
            )
        }
    }
}
