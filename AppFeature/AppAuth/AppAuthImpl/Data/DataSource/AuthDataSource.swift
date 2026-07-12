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
    
    func sendOptionals(
        multiPart: MultipartFormData?,
        queryData: AuthDTOModel.OptionalsQuery?
    ) async throws(APIError) -> Data
    
    func getLanguages() async throws(APIError) -> [AuthDTOModel.LanguagesResponse]
    
    func getCategories() async throws(APIError) -> [AuthDTOModel.CategoriesResponse]
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
    
    func sendOptionals(
        multiPart: MultipartFormData?,
        queryData: AuthDTOModel.OptionalsQuery?
    ) async throws(APIError) -> Data {
        try await fetchRawData(
            endPoint: .sendOptionals(
                multiPart,
                queryData?.toDictionary()
            )
        )
    }
    
    func getLanguages() async throws(APIError) -> [AuthDTOModel.LanguagesResponse] {
        try await fetch(endPoint: .getLanguages)
    }
    
    func getCategories() async throws(APIError) -> [AuthDTOModel.CategoriesResponse] {
        try await fetch(endPoint: .getCategories)
    }
}
