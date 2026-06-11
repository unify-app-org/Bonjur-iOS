//
//  GroupsDataSource.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 23.01.26.
//

import Foundation
import AppNetwork

protocol GroupsDataSource {
    func fetchJoinedClubs(
        query: [String: String]
    ) async throws(APIError) -> PageNationResponse<[GroupsDTOModel.Club]>
    
    func fetchJoinedHangouts(
        query: [String: String]
    ) async throws(APIError) -> PageNationResponse<[GroupsDTOModel.Hangout]>

    func fetchJoinedEvents(
        query: [String: String]
    ) async throws(APIError) -> PageNationResponse<[GroupsDTOModel.Event]>
}

class GroupsDataSourceImpl: NetworkService<GroupsEndPoint>, GroupsDataSource {
    func fetchJoinedClubs(
        query: [String: String]
    ) async throws(APIError) -> PageNationResponse<[GroupsDTOModel.Club]> {
        try await fetch(endPoint: .joinedClubs(query))
    }
    
    func fetchJoinedHangouts(
        query: [String: String]
    ) async throws(APIError) -> PageNationResponse<[GroupsDTOModel.Hangout]> {
        try await fetch(endPoint: .joinedHangouts(query))
    }

    func fetchJoinedEvents(
        query: [String: String]
    ) async throws(APIError) -> PageNationResponse<[GroupsDTOModel.Event]> {
        try await fetch(endPoint: .joinedEvents(query))
    }
}
