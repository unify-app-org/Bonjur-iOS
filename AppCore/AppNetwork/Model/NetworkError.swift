//
//  NetworkError.swift
//  AppCore
//
//  Created by Huseyn Hasanov on 24.11.25.
//

import Foundation

public struct NetworkError: Decodable, LocalizedError {
    let status: String?
    let message: String?
    let detail: String?
    let path: String?
    let error: String?
    let errors: [String: [String]]?
    
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
            return networkError.errorDescription ?? ""
        case .unauthorized:
            return "Unauthorized. Please login again."
        case .networkError(let error):
            return error.localizedDescription
        case .unknown:
            return "An unknown error occurred"
        }
    }
    
    public var detail: String? {
        switch self {
        case .invalidURL:
            nil
        case .noData:
            nil
        case .decodingError(let error):
            nil
        case .error(let networkError):
            networkError.failureReason
        case .unauthorized:
            nil
        case .networkError(let error):
            nil
        case .unknown:
            nil
        }
    }
}
