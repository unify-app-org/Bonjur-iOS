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
    ) async throws(APIError) -> Bool
    
    func getCommunityList() async throws(APIError) -> [SelectableListItemView.Model]
    
    func sendOptionals(
        multiPart: MultipartFormData?,
        queryData: AuthDTOModel.OptionalsQuery?
    ) async throws(APIError) -> Data
    
    func getLanguages() async throws(APIError) -> [SelectableListItemView.Model]
    
    func getCategories() async throws(APIError) -> [AuthUIModel.Interests]
}

class AuthRepoImpl: AuthRepo {
    
    private let dataSource: AuthDataSource
    private let tokenManager: TokenManager
    private let userDefaults: UserDefaultsProtocol

    init(
        dataSource: AuthDataSource = resolve(),
        tokenManager: TokenManager = resolve(),
        userDefaults: UserDefaultsProtocol = resolve()
    ) {
        self.dataSource = dataSource
        self.tokenManager = tokenManager
        self.userDefaults = userDefaults
    }
    
    func login(
        communityId: Int,
        email: String,
        password: String?
    ) async throws(APIError) -> Bool {
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
        userDefaults.set(true, forKey: .isAuthenticated)
        await tokenManager.saveAccessToken(data.accessToken)
        await tokenManager.saveRefreshToken(data.refreshToken)
        await tokenManager.saveUserId(data.userId)
        return data.isFirstLogin
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
    
    func getCategories() async throws(APIError) -> [AuthUIModel.Interests] {
        let data = try await dataSource.getCategories()
        let uiModel: [AuthUIModel.Interests] = data.map { item in
            let interests: [CategoriesChipsView.Model] = item.subCategories.map { item in
                    .init(
                        id: item.id ?? 0,
                        title: item.title ?? "",
                        selected: false
                    )
            }
            return .init(
                    type: item.type ?? "",
                    title: item.title ?? "",
                    interests: interests
                )
        }
        return uiModel
    }
}
