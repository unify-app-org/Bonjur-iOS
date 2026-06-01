//
//  DiscoverRepo.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 11.05.26.
//

import Clubs
import Events
import Hangouts
import AppUIKit
import AppStorage
import Foundation
import AppNetwork
import Communities
import AppPresentationModel

protocol DiscoverRepo {
    
    func getHangout(
        query: DiscoverDTOModel.PaginationQuery
    ) async throws(APIError) -> [HangoutsModuleModel.CardInputData]
    
    func getClubs(
        query: DiscoverDTOModel.PaginationQuery
    ) async throws(APIError) -> [ClubsModuleModel.CardInputData]
    
    func getCommunities(
        query: DiscoverDTOModel.PaginationQuery
    ) async throws(APIError) -> [CommunitiesModuleModel.CardInputData]
    
    func getCategories() async throws(APIError) -> [FilterView.Model]
    
    func getUser() async throws(APIError) -> UserModel
    
    func joinHangout(
        request: DiscoverDTOModel.JoinHangoutRequest
    ) async throws(APIError)
}

class DiscoverRepoImpl: DiscoverRepo {
    private let dataSource: DiscoverDataSource
    private let tokenManger: TokenManager
    private let userDefault: UserDefaultsProtocol
    
    init(
        dataSource: DiscoverDataSource = resolve(),
        tokenManger: TokenManager = resolve(),
        userDefault: UserDefaultsProtocol = resolve()
    ) {
        self.dataSource = dataSource
        self.tokenManger = tokenManger
        self.userDefault = userDefault
    }
    
    func getHangout(
        query: DiscoverDTOModel.PaginationQuery
    ) async throws(APIError) -> [HangoutsModuleModel.CardInputData] {
        let data = try await dataSource.getHangout(query: query.toDictionary())
        let uiModel: [HangoutsModuleModel.CardInputData] = data.map { item in
            let tags: [AppPresentationModel.Tags] = item.categoryResponses.map { item in
                .init(
                    id: item.id ?? 0,
                    type: "",
                    title: item.title ?? "-"
                )
            }
            return .init(
                    id: item.id ?? "-",
                    name: item.name ?? "-",
                    description: item.about ?? "-",
                    memberCount: item.membersCount ?? 0,
                    totalCapacity: item.capacity ?? 0,
                    tags: tags,
                    accessType: item.visibility ?? .private,
                    requestType: item.requestStatus ?? .none
                )
        }
        return uiModel
    }
    
    func getClubs(
        query: DiscoverDTOModel.PaginationQuery
    ) async throws(APIError) -> [ClubsModuleModel.CardInputData] {
        var dict = query.toDictionary()
        dict["parentId"] = String(userDefault.integer(forKey: .communityId))
        let data = try await dataSource.getClubs(
            query: dict
        )
        let uiModel: [ClubsModuleModel.CardInputData] = data.map { item in
            let members: [AppPresentationModel.Member] = item.members?.map { member in
                    .init(
                        id: member.id ?? "",
                        profileImage: member.url ?? ""
                    )
            } ?? []
            return .init(
                    id: item.id ?? 0,
                    name: item.name ?? "-",
                    communityName: item.communityName ?? "-",
                    logoURL: item.clubProfile ?? "",
                    memberCount: item.count ?? 0,
                    totalCapacity: 0,
                    community: item.communityName ?? "-",
                    members: members,
                    bgType: item.background ?? .primary,
                    accessType: .private,
                    requestType: .joined
                )
        }
        return uiModel
    }
    
    func getCommunities(
        query: DiscoverDTOModel.PaginationQuery
    ) async throws(APIError) -> [CommunitiesModuleModel.CardInputData] {
        let data = try await dataSource.getCommunities(
            query: query.toDictionary()
        )
        let uiModel: [CommunitiesModuleModel.CardInputData] = data.map { item in
            let members: [AppPresentationModel.Member] = item.members?.map { member in
                    .init(
                        id: member.id ?? "",
                        profileImage: member.url ?? ""
                    )
            } ?? []
            return .init(
                    id: item.id ?? 0,
                    name: item.name ?? "-",
                    subTitle: "Community",
                    logoURL: item.profile ?? "",
                    memberCount: item.membersCount ?? 0,
                    members: members ,
                    bgType: item.background ?? .primary
                )
        }
        return uiModel
    }
    
    func getCategories() async throws(APIError) -> [FilterView.Model] {
        let data = try await dataSource.getCategories()
        return data.map { item in
            let items = item.subCategories.map { subCategory in
                FilterView.Items(
                    title: subCategory.title ?? "",
                    id: subCategory.id ?? 0
                )
            }
            
            return FilterView.Model(
                title: item.title ?? "",
                type: item.type ?? "",
                items: items
            )
        }
    }
    
    func getUser() async throws(APIError) -> UserModel {
        let userId = await tokenManger.getUserId()
        let data = try await dataSource.getUser(
            userId: userId
        )
        return .init(
            name: data.fullName ?? "-",
            profileImage: data.fileUrl ?? "",
            greeting: data.greeting ?? ""
        )
    }
    
    func joinHangout(
        request: DiscoverDTOModel.JoinHangoutRequest
    ) async throws(APIError) {
        let _ = try await dataSource.joinHangout(request: request)
    }
}
