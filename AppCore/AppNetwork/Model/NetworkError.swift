//
//  NetworkError.swift
//  AppCore
//
//  Created by Huseyn Hasanov on 24.11.25.
//

import Foundation

public struct NetworkError: Decodable, LocalizedError {
    public let status: String
    public let message: String
    public let detail: String?
    public let errors: [String: [String]]?
    
    enum CodingKeys: String, CodingKey {
        case status
        case message
        case detail
        case errors
    }
    
    public var errorDescription: String? {
        return message
    }
    
    public var failureReason: String? {
        return detail
    }
}

public enum APIError: Error {
    case invalidURL
    case noData
    case decodingError(Error)
    case error(NetworkError)
    case unauthorized
    case networkError(Error)
    case unknown
    
    public var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received"
        case .decodingError(let error):
            return "Failed to decode: \(error.localizedDescription)"
        case .error(let networkError):
            return networkError.message
        case .unauthorized:
            return "Unauthorized. Please login again."
        case .networkError(let error):
            return error.localizedDescription
        case .unknown:
            return "An unknown error occurred"
        }
    }
}
