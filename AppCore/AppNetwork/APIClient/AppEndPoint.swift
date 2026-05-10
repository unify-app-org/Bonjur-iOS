//
//  Endpoint.swift
//  AppCore
//
//  Created by Huseyn Hasanov on 24.11.25.
//

import Foundation

// MARK: - Endpoint Protocol

public protocol AppEndPoint {
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var requiresAuth: Bool { get }
    var body: Encodable? { get }
    var queryParameters: [String: String]? { get }
    var multipartFormData: MultipartFormData? { get }
    var contentType: ContentType { get }
}

public extension AppEndPoint {
    var headers: [String: String]? {
        return [:]
    }
    
    var requiresAuth: Bool {
        return true
    }
    
    var body: Encodable? {
        return nil
    }
    
    var queryParameters: [String: String]? {
        return nil
    }
    
    var multipartFormData: MultipartFormData? {
        return nil
    }
    
    var contentType: ContentType {
        return .json
    }
}

public enum ContentType: String {
    case json = "application/json"
    case formData = "multipart/form-data; boundary=Boundary-12345"
}

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}
