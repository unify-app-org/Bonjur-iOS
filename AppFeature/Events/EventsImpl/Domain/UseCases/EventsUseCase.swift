//
//  EventsUseCase.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 22.01.26.
//

import Foundation
import AppUIKit
import AppNetwork
import Communities

protocol EventsUseCase {
    func fetchEvents() async throws(APIError) -> [EventsCardView.Model]
    func fetchEventDetail(eventId: String) async throws(APIError) -> EventsDetailsModel.UIModel
    func fetchEventMembers(
        eventId: String
    ) async throws(APIError) -> CommunitiesMemberModuleModel.GroupedMembersData
    func createEvent(request: MultipartFormData) async throws(APIError)
    func fetchClubsForEvents() async throws(APIError) -> [EventsCreate.SelectableClub]
    func getCategories() async throws(APIError) -> [SelectCategoryView.Section]
}

class EventsUseCaseImpl: EventsUseCase {

    private let repo: EventsRepo

    init(repo: EventsRepo = resolve()) {
        self.repo = repo
    }

    func fetchEvents() async throws(APIError) -> [EventsCardView.Model] {
        EventsCardView.Model.previewMock
    }

    func fetchEventDetail(
        eventId: String
    ) async throws(APIError) -> EventsDetailsModel.UIModel {
        try await repo.fetchEventDetail(eventId: eventId)
    }

    func fetchEventMembers(
        eventId: String
    ) async throws(APIError) -> CommunitiesMemberModuleModel.GroupedMembersData {
        try await repo.fetchEventMembers(eventId: eventId)
    }

    func createEvent(request: MultipartFormData) async throws(APIError) {
        try await repo.createEvent(request: request)
    }

    func fetchClubsForEvents() async throws(APIError) -> [EventsCreate.SelectableClub] {
        try await repo.fetchClubsForEvents()
    }

    func getCategories() async throws(APIError) -> [SelectCategoryView.Section] {
        try await repo.getCategories()
    }
}
