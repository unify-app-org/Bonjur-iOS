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
}

final class DiscoverDataSourceImpl: NetworkService<DiscoverEndPoint>, DiscoverDataSource {
    
    func getHangout(
        query: [String : String]
    ) async throws(APIError) -> [DiscoverDTOModel.Hangout] {
        try await fetch(endPoint: .getHangouts(query))
    }
}
