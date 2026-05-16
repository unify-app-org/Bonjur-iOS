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
    
    enum CodingKeys: String, CodingKey {
        case status
        case message
        case detail
        case path
        case error
        case errors
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let statusCode = try? container.decodeIfPresent(Int.self, forKey: .status) {
            status = String(statusCode)
        } else {
            status = try container.decodeIfPresent(String.self, forKey: .status)
        }
        message = try container.decodeIfPresent(String.self, forKey: .message)
        detail = try container.decodeIfPresent(String.self, forKey: .detail)
        path = try container.decodeIfPresent(String.self, forKey: .path)
        error = try container.decodeIfPresent(String.self, forKey: .error)
        errors = try? container.decodeIfPresent([String: [String]].self, forKey: .errors)
    }
    
    public var errorDescription: String? {
        return message ?? detail ?? error
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
        case .decodingError(_):
            nil
        case .error(let networkError):
            networkError.failureReason
        case .unauthorized:
            nil
        case .networkError(_):
            nil
        case .unknown:
            nil
        }
    }
}
