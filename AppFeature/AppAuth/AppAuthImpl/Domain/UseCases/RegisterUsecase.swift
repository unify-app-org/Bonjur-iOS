//
//  LogInUsecase.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 25.11.25.
//

import AppNetwork

protocol RegisterUsecase {
    func register(
        body: RegisterRequest
    ) async throws(APIError) -> RegisterModel
}

final class RegisterUsecaseImpl: RegisterUsecase {
    
    private let dataSource: AuthDataSource
    
    init(dataSource: AuthDataSource = resolve()) {
        self.dataSource = dataSource
    }
    
    func register(
        body: RegisterRequest
    ) async throws(APIError) -> RegisterModel {
        let data = try await dataSource.register(body: body)
        return RegisterModel(
            token: data.token,
            refreshToken: data.refreshToken
        )
    }
}
