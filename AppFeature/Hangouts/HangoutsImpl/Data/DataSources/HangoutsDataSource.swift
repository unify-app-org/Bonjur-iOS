//
//  HangoutsDataSource.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 22.01.26.
//

import Foundation
import AppNetwork

protocol HangoutsDataSource {
    func fetchHangouts(
        query: [String: String]
    ) async throws(APIError) -> [HangoutsDTOModel.Hangout]
    
    func createHangout(
        request: HangoutsDTOModel.Request
    ) async throws(APIError) -> Data
    
    func editHangout(
        id: String,
        request: HangoutsDTOModel.Request
    ) async throws(APIError) -> Data
    
    func getCategories() async throws(APIError) -> [HangoutsDTOModel.CategoriesResponse]
    
    func fetchHangoutsDetail(
        id: String
    ) async throws(APIError) -> HangoutsDTOModel.HangoutDetail
    
    func fetchMembers(
        id: String
    ) async throws(APIError) -> PageNationResponse<[HangoutsDTOModel.MemberResponse]>
}

final class HangoutsDataSourceImpl: NetworkService<HangoutsEndPoint>, HangoutsDataSource {
    
    func fetchHangouts(
        query: [String: String]
    ) async throws(APIError) -> [HangoutsDTOModel.Hangout] {
        try await fetch(endPoint: .getHangouts(query))
    }
    
    func createHangout(
        request: HangoutsDTOModel.Request
    ) async throws(APIError) -> Data {
        try await fetchRawData(endPoint: .createHangout(request))
    }
    
    func editHangout(
        id: String,
        request: HangoutsDTOModel.Request
    ) async throws(APIError) -> Data {
        try await fetchRawData(endPoint: .editHangout(id, request))
    }
    
    func getCategories() async throws(APIError) -> [HangoutsDTOModel.CategoriesResponse] {
        try await fetch(endPoint: .getCategories)
    }
    
    func fetchHangoutsDetail(
        id: String
    ) async throws(APIError) -> HangoutsDTOModel.HangoutDetail {
        try await fetch(endPoint: .hangoutDetail(id))
    }
    
    func fetchMembers(
        id: String
    ) async throws(APIError) -> PageNationResponse<[HangoutsDTOModel.MemberResponse]> {
        try await fetch(endPoint: .members(id))
    }
}
