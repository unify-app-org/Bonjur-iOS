//
//  EventsDataSource.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 22.01.26.
//

import Foundation
import AppNetwork

protocol EventsDataSource {
    func fetchClubsForEvents() async throws(APIError) -> PageNationResponse<[ClubForEventDTO]>
    func getCategories() async throws(APIError) -> [EventCategoriesResponse]
    func createEvent(request: MultipartFormData) async throws(APIError) -> Data
    func fetchEventDetail(eventId: String) async throws(APIError) -> EventDetailDTO
    func fetchEventMembers(
        eventId: String,
        query: [String: String]
    ) async throws(APIError) -> EventMembersResponse
    func fetchDiscoverEvents(
        query: [String: String]
    ) async throws(APIError) -> [EventDiscoverDTO]
    func joinEvent(eventId: String) async throws(APIError) -> Data
    func editEvent(eventId: String, request: MultipartFormData) async throws(APIError) -> Data
    func exitEvent(eventId: String) async throws(APIError) -> Data
}

final class EventsDataSourceImpl: NetworkService<EventsEndPoint>, EventsDataSource {

    func fetchClubsForEvents() async throws(APIError) -> PageNationResponse<[ClubForEventDTO]> {
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

    func fetchDiscoverEvents(
        query: [String: String]
    ) async throws(APIError) -> [EventDiscoverDTO] {
        try await fetch(endPoint: .discoverEvents(query))
    }

    func joinEvent(eventId: String) async throws(APIError) -> Data {
        try await fetchRawData(endPoint: .joinEvent(eventId))
    }

    func editEvent(eventId: String, request: MultipartFormData) async throws(APIError) -> Data {
        try await fetchRawData(endPoint: .editEvent(eventId, request))
    }

    func exitEvent(eventId: String) async throws(APIError) -> Data {
        try await fetchRawData(endPoint: .exitEvent(eventId))
    }
}
