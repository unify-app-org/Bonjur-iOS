//
//  AuthDataSource.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 24.11.25.
//
import Foundation
import AppNetwork

protocol AuthDataSource {
    func register(
        body: RegisterRequest
    ) async throws(APIError) -> RegisterResponse
}

final class AuthDataSourceImpl: NetworkService<AuthEnpoints>, AuthDataSource {
    
    func register(
        body: RegisterRequest
    ) async throws(APIError) -> RegisterResponse {
        try await fetch(endPoint: .register(body))
    }
    
}
