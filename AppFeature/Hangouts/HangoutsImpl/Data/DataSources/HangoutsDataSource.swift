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
    
    func fetchHangoutsDetail(
        id: String
    ) async throws(APIError) -> HangoutsDTOModel.HangoutDetail
}

final class HangoutsDataSourceImpl: NetworkService<HangoutsEndPoint>, HangoutsDataSource {
    
    func fetchHangouts(
        query: [String: String]
    ) async throws(APIError) -> [HangoutsDTOModel.Hangout] {
        try await fetch(endPoint: .getHangouts(query))
    }
    
    func fetchHangoutsDetail(
        id: String
    ) async throws(APIError) -> HangoutsDTOModel.HangoutDetail {
        try await fetch(endPoint: .hangoutDetail(id))
    }
}
