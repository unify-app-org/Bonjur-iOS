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
}

final class HangoutsDataSourceImpl: NetworkService<HangoutsEndPoint>, HangoutsDataSource {
    
    func fetchHangouts(
        query: [String: String]
    ) async throws(APIError) -> [HangoutsDTOModel.Hangout] {
        try await fetch(endPoint: .getHangouts(query))
    }
}
