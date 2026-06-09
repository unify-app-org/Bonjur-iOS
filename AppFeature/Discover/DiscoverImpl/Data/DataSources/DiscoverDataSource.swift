//
//  DiscoverDataSource.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 17.01.26.
//

import Foundation
import AppNetwork
import AppPresentationModel

protocol DiscoverDataSource {
    func getHangout(
        query: [String: String]
    ) async throws(APIError) -> [DiscoverDTOModel.Hangout]
    
    func getClubs(
        query: [String: String]
    ) async throws(APIError) -> [DiscoverDTOModel.Club]
    
    func getCommunities(
        query: [String: String]
    ) async throws(APIError) -> [DiscoverDTOModel.Community]

    func getEvents(
        query: [String: String]
    ) async throws(APIError) -> [DiscoverDTOModel.Event]

    func getCategories() async throws(APIError) -> [DiscoverDTOModel.CategoriesResponse]
    
    func getUser(
        userId: String
    ) async throws(APIError) -> AppPresentationModel.UserResponse
    
    func joinHangout(
        request: Encodable
    ) async throws(APIError) -> Data
}

final class DiscoverDataSourceImpl: NetworkService<DiscoverEndPoint>, DiscoverDataSource {
    
    func getHangout(
        query: [String : String]
    ) async throws(APIError) -> [DiscoverDTOModel.Hangout] {
        try await fetch(endPoint: .getHangouts(query))
    }
    
    func getClubs(
        query: [String : String]
    ) async throws(APIError) -> [DiscoverDTOModel.Club] {
        try await fetch(endPoint: .getClubs(query))
    }
    
    func getCommunities(
        query: [String : String]
    ) async throws(APIError) -> [DiscoverDTOModel.Community] {
        try await fetch(endPoint: .getCommunities(query))
    }
    
    func getEvents(
        query: [String : String]
    ) async throws(APIError) -> [DiscoverDTOModel.Event] {
        try await fetch(endPoint: .getEvents(query))
    }

    func getCategories() async throws(APIError) -> [DiscoverDTOModel.CategoriesResponse] {
        try await fetch(endPoint: .getCategories)
    }
    
    func getUser(
        userId: String
    ) async throws(APIError) -> AppPresentationModel.UserResponse {
        try await fetch(endPoint: .getUserById(userId))
    }
    
    func joinHangout(
        request: Encodable
    ) async throws(APIError) -> Data {
        try await fetchRawData(endPoint: .joinHangout(request))
    }
}
