//
//  NetworkService.swift
//  AppCore
//
//  Created by Huseyn Hasanov on 25.11.25.
//

import Foundation

open class NetworkService<EndPoint: AppEndPoint> {
    
    private let apiClient: APIClientProtocol = resolve()
    
    public init() { }
    
    public func fetch<T: Decodable>(
        endPoint: EndPoint
    ) async throws(APIError) -> T {
        return try await apiClient.request(endPoint)
    }
    
    public func fetchRawData(
        endPoint: EndPoint
    ) async throws(APIError) -> Data {
        return try await apiClient.requestRawData(endPoint)
    }
}
