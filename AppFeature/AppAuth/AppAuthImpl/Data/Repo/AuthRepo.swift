//
//  AuthRepo.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 19.03.26.
//

import AppStorage
import AppNetwork

protocol AuthRepo {
    func login(
        email: String, password: String?
    ) async throws(APIError)
}

class AuthRepoImpl: AuthRepo {
    
    private let dataSource: AuthDataSource
    private let tokenManager: TokenManager
    
    init(
        dataSource: AuthDataSource = resolve(),
        tokenManager: TokenManager = resolve()
    ) {
        self.dataSource = dataSource
        self.tokenManager = tokenManager
    }
    
    func login(
        email: String, password: String?
    ) async throws(APIError) {
        let deviceManager = DeviceManager.shared
        let body: AuthDTOModel.LoginRequest = .init(
            mail: email,
            deviceId: deviceManager.deviceId,
            devicePlatform: deviceManager.devicePlatform,
            deviceOs: deviceManager.deviceOs,
            deviceModel: deviceManager.deviceModel,
            appVersion: deviceManager.appVersion,
            password: password
        )
        let data = try await dataSource.login(body: body)
        await tokenManager.saveAccessToken(data.accessToken)
        await tokenManager.saveRefreshToken(data.refreshToken)
        await tokenManager.saveUserId(data.userId)
    }
}
