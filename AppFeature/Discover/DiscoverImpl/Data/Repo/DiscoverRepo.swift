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
import AppUtils
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

    func getEvents(
        query: DiscoverDTOModel.PaginationQuery
    ) async throws(APIError) -> [EventsModuleModel.CardInputData]

    func getCategories() async throws(APIError) -> [FilterView.Model]
    
    func getUser() async throws(APIError) -> UserModel
    
    func joinHangout(
        request: DiscoverDTOModel.JoinHangoutRequest
    ) async throws(APIError)
    
    func joinEvent(
        request: DiscoverDTOModel.JoinEventRequest
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
                    requestType: item.requestStatus ?? .none,
                    location: item.location,
                    hangoutDate: Date.fromISO8601(item.hangoutDate),
                    role: item.role
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
                    memberCount: item.memberCount ?? 0,
                    totalCapacity: item.capacity ?? 0,
                    community: item.communityName ?? "-",
                    members: members,
                    bgType: item.background ?? .primary,
                    accessType: item.visibility ?? .private,
                    requestType: item.requestStatus ?? .none,
                    role: item.role ?? .notJoined,
                    upcomingEventsCount: item.eventCount ?? 0,
                    categories: (item.categoryResponses ?? []).map {
                        .init(id: $0.id ?? 0, title: $0.title ?? "-")
                    },
                    isVerified: item.clubStatus?.isVerified ?? false
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
                    clubCount: item.clubCount ?? 0,
                    members: members ,
                    bgType: item.background ?? .primary,
                    role: item.role
                )
        }
        return uiModel
    }
    
    func getEvents(
        query: DiscoverDTOModel.PaginationQuery
    ) async throws(APIError) -> [EventsModuleModel.CardInputData] {
        let data = try await dataSource.getEvents(query: query.toDictionary())
        let uiModel: [EventsModuleModel.CardInputData] = data.map { item in
            let tags: [AppPresentationModel.Tags] = item.categoryResponses.map { category in
                .init(
                    id: category.id ?? 0,
                    type: "",
                    title: category.title ?? "-"
                )
            }
            return .init(
                id: item.id ?? "-",
                name: item.name ?? "-",
                coverimageURL: item.background,
                memberCount: item.membersCount ?? 0,
                totalCapacity: item.capacity ?? 0,
                club: .init(name: item.club?.name ?? "-", id: item.club?.id ?? 0),
                tags: tags,
                bgType: .primary,
                requestType: item.requestStatus ?? .none,
                accessType: item.visibility ?? .private,
                role: item.role ?? .notJoined,
                location: item.location ?? "-",
                eventDate: Date.fromISO8601(item.eventDate) ?? Date()
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
    
    func joinEvent(
        request: DiscoverDTOModel.JoinEventRequest
    ) async throws(APIError) {
        let _ = try await dataSource.joinEvent(id: request.eventId)
    }
}
