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
}

final class EventsDataSourceImpl: NetworkService<EventsEndPoint>, EventsDataSource {

    func fetchClubsForEvents() async throws(APIError) -> [ClubForEventDTO] {
        try await fetch(endPoint: .clubsForEvents)
    }

    func getCategories() async throws(APIError) -> [EventCategoriesResponse] {
        try await fetch(endPoint: .getCategories)
    }
}
