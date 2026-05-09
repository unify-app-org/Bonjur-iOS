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
    
    func communityData() async throws(APIError) -> [AuthDTOModel.CommunitiesResponse]
}

final class AuthDataSourceImpl: NetworkService<AuthEnpoints>, AuthDataSource {
    
    func login(
        body: AuthDTOModel.LoginRequest
    ) async throws(APIError) -> AuthDTOModel.LoginResponse {
        try await fetch(endPoint: .login(body))
    }
    
    func communityData() async throws(APIError) -> [AuthDTOModel.CommunitiesResponse] {
        try await fetch(endPoint: .getCommunities)
    }
}
