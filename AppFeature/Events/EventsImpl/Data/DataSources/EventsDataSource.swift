//
//  EventsDataSource.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 22.01.26.
//

import Foundation
import AppNetwork

protocol EventsDataSource {
    func fetchClubsForEvents() async throws(APIError) -> [ClubForEventDTO]
    func getCategories() async throws(APIError) -> [EventCategoriesResponse]
    func createEvent(request: MultipartFormData) async throws(APIError) -> Data
    func fetchEventDetail(eventId: String) async throws(APIError) -> EventDetailDTO
    func fetchEventMembers(
        eventId: String,
        query: [String: String]
    ) async throws(APIError) -> EventMembersResponse
}

final class EventsDataSourceImpl: NetworkService<EventsEndPoint>, EventsDataSource {

    func fetchClubsForEvents() async throws(APIError) -> [ClubForEventDTO] {
        try await fetch(endPoint: .clubsForEvents)
    }

    func getCategories() async throws(APIError) -> [EventCategoriesResponse] {
        try await fetch(endPoint: .getCategories)
    }

    func createEvent(request: MultipartFormData) async throws(APIError) -> Data {
        try await fetchRawData(endPoint: .createEvent(request))
    }

    func fetchEventDetail(eventId: String) async throws(APIError) -> EventDetailDTO {
        try await fetch(endPoint: .eventDetail(eventId))
    }

    func fetchEventMembers(
        eventId: String,
        query: [String: String]
    ) async throws(APIError) -> EventMembersResponse {
        try await fetch(endPoint: .eventMembers(eventId, query))
    }
}
