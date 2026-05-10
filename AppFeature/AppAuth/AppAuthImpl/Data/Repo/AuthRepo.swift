//
//  AuthRepo.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 19.03.26.
//

import AppStorage
import AppNetwork
import AppUIKit
import Foundation
import AppUtils

protocol AuthRepo {
    func login(
        communityId: Int,
        email: String,
        password: String?
    ) async throws(APIError)
    
    func getCommunityList() async throws(APIError) -> [SelectableListItemView.Model]
    
    func sendOptionals(
        multiPart: MultipartFormData?,
        queryData: AuthDTOModel.OptionalsQuery?
    ) async throws(APIError) -> Data
    
    func getLanguages() async throws(APIError) -> [SelectableListItemView.Model]
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
        communityId: Int,
        email: String,
        password: String?
    ) async throws(APIError) {
        let deviceManager = DeviceManager.shared
        let body: AuthDTOModel.LoginRequest = .init(
            mail: email,
            deviceId: deviceManager.deviceId,
            devicePlatform: deviceManager.devicePlatform,
            communityId: communityId,
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
    
    func getCommunityList() async throws(APIError) -> [SelectableListItemView.Model] {
        let data = try await dataSource.communityData()
        let uiModel: [SelectableListItemView.Model] = data.map { item in
                .init(id: item.id, title: item.name, selected: false)
        }
        return uiModel
    }
    
    func sendOptionals(
        multiPart: MultipartFormData?,
        queryData: AuthDTOModel.OptionalsQuery?
    ) async throws(APIError) -> Data {
        try await dataSource.sendOptionals(
            multiPart: multiPart,
            queryData: queryData
        )
    }
    
    func getLanguages() async throws(APIError) -> [SelectableListItemView.Model] {
        let data = try await dataSource.getLanguages()
        let uiModel: [SelectableListItemView.Model] = data.map { item in
                .init(
                    id: item.id,
                    title: item.name ?? "",
                    selected: false
                )
        }
        return uiModel
    }
}
