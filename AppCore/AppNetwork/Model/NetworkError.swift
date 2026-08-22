//
//  NetworkError.swift
//  AppCore
//
//  Created by Huseyn Hasanov on 24.11.25.
//

import Foundation
import AppLocalization

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

    /// The server's field validation messages, flattened. `errors` is keyed by
    /// field, so the keys are sorted to keep the order stable between calls.
    public var userMessages: [String] {
        guard let errors else { return [] }
        return errors
            .sorted { $0.key < $1.key }
            .flatMap(\.value)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
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
    
    /// Title for every error popup. `message` is a raw server/exception string
    /// ("No enum constant …EventUserRole.REQUESTED") and must never be shown to
    /// a user, so the title is always the same generic line.
    public static var popupTitle: String {
        "error_generic_title".localized
    }

    /// The server's `errors` entries, comma separated. Falls back to a generic
    /// line — the backend sends `errors: null` on plenty of failures, and an
    /// empty popup body is worse than a vague one.
    public var popupSubtitle: String {
        guard case .error(let networkError) = self else {
            return "error_generic_subtitle".localized
        }
        let messages = networkError.userMessages
        return messages.isEmpty
            ? "error_generic_subtitle".localized
            : messages.joined(separator: ", ")
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

public extension Optional where Wrapped == APIError {

    /// Lets a call site read the subtitle straight off an optional error.
    var popupSubtitle: String {
        self?.popupSubtitle ?? "error_generic_subtitle".localized
    }
}
