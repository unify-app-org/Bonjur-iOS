//
//  AuthDataSource.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 24.11.25.
//
import Foundation
import AppNetwork

protocol AuthDataSource {
    func login(
        body: AuthDTOModel.LoginRequest
    ) async throws(APIError) -> AuthDTOModel.LoginResponse
}

final class AuthDataSourceImpl: NetworkService<AuthEnpoints>, AuthDataSource {
    
    func login(
        body: AuthDTOModel.LoginRequest
    ) async throws(APIError) -> AuthDTOModel.LoginResponse {
        try await fetch(endPoint: .login(body))
    }
}
