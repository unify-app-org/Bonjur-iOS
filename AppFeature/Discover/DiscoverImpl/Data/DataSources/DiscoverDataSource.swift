//
//  DiscoverDataSource.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 17.01.26.
//

import Foundation
import AppNetwork

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
    
    func getUser() async throws(APIError) -> DiscoverDTOModel.User
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
    
    func getUser() async throws(APIError) -> DiscoverDTOModel.User {
        try await fetch(endPoint: .getUser)
    }
}
