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
    func fetchEvents(categoryIds: [Int]) async throws(APIError) -> [EventsCardView.Model]
    func joinEvent(eventId: String) async throws(APIError)
    func exitEvent(eventId: String) async throws(APIError)
    func fetchEventDetail(eventId: String) async throws(APIError) -> EventsDetailsModel.UIModel
    func fetchEventMembers(
        eventId: String
    ) async throws(APIError) -> CommunitiesMemberModuleModel.GroupedMembersData
    func fetchEventMembersPage(
        eventId: String,
        page: Int,
        size: Int
    ) async throws(APIError) -> CommunitiesMemberModuleModel.MembersPage
    func createEvent(request: MultipartFormData) async throws(APIError)
    func editEvent(eventId: String, request: MultipartFormData) async throws(APIError)
    func fetchClubsForEvents() async throws(APIError) -> [EventsCreate.SelectableClub]
    func getCategories() async throws(APIError) -> [SelectCategoryView.Section]
    func getFilterCategories() async throws(APIError) -> [FilterView.Model]
}

class EventsUseCaseImpl: EventsUseCase {

    private let repo: EventsRepo

    init(repo: EventsRepo = resolve()) {
        self.repo = repo
    }

    func fetchEvents(categoryIds: [Int]) async throws(APIError) -> [EventsCardView.Model] {
        try await repo.fetchEvents(categoryIds: categoryIds).map(EventsCardView.Model.init(from:))
    }

    func joinEvent(eventId: String) async throws(APIError) {
        try await repo.joinEvent(eventId: eventId)
    }

    func exitEvent(eventId: String) async throws(APIError) {
        try await repo.exitEvent(eventId: eventId)
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

    func fetchEventMembersPage(
        eventId: String,
        page: Int,
        size: Int
    ) async throws(APIError) -> CommunitiesMemberModuleModel.MembersPage {
        try await repo.fetchEventMembersPage(eventId: eventId, page: page, size: size)
    }

    func createEvent(request: MultipartFormData) async throws(APIError) {
        try await repo.createEvent(request: request)
    }

    func editEvent(eventId: String, request: MultipartFormData) async throws(APIError) {
        try await repo.editEvent(eventId: eventId, request: request)
    }

    func fetchClubsForEvents() async throws(APIError) -> [EventsCreate.SelectableClub] {
        try await repo.fetchClubsForEvents()
    }

    func getCategories() async throws(APIError) -> [SelectCategoryView.Section] {
        try await repo.getCategories()
    }

    func getFilterCategories() async throws(APIError) -> [FilterView.Model] {
        try await repo.getFilterCategories()
    }
}
