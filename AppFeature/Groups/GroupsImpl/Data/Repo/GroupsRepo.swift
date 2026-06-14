//
//  GroupsRepo.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 26.05.26.
//

import AppNetwork
import AppUIKit
import Clubs
import Events
import Foundation
import Hangouts

protocol GroupsRepo {
    func fetchJoinedClubs(
        query: GroupsDTOModel.PaginationQuery
    ) async throws(APIError) -> [ClubsModuleModel.CardInputData]

    func fetchJoinedHangouts(
        query: GroupsDTOModel.PaginationQuery
    ) async throws(APIError) -> [HangoutsModuleModel.CardInputData]

    func fetchJoinedEvents(
        query: GroupsDTOModel.PaginationQuery
    ) async throws(APIError) -> [EventsModuleModel.CardInputData]
}

final class GroupsRepoImpl: GroupsRepo {
    private let dataSource: GroupsDataSource
    
    init(dataSource: GroupsDataSource = resolve()) {
        self.dataSource = dataSource
    }
    
    func fetchJoinedClubs(
        query: GroupsDTOModel.PaginationQuery
    ) async throws(APIError) -> [ClubsModuleModel.CardInputData] {
        let data = try await dataSource.fetchJoinedClubs(
            query: query.toDictionary()
        ).content
        
        return data.map { item in
            let members: [AppUIEntities.Member] = item.members?.map { member in
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
                totalCapacity: item.capacity ?? 0,
                community: item.communityName ?? "-",
                members: members,
                bgType: item.background ?? .primary,
                accessType: item.visibility ?? .private,
                requestType: item.status ?? .none,
                role: item.role ?? .notJoined
            )
        }
    }
    
    func fetchJoinedHangouts(
        query: GroupsDTOModel.PaginationQuery
    ) async throws(APIError) -> [HangoutsModuleModel.CardInputData] {
        let data = try await dataSource.fetchJoinedHangouts(
            query: query.toDictionary()
        ).content
        
        return data.map { item in
            let tags: [AppUIEntities.Tags] = item.categories.map { category in
                .init(
                    id: category.id ?? 0,
                    type: "",
                    title: category.title ?? "-"
                )
            }
            
            return .init(
                id: item.id ?? "-",
                name: item.name ?? "-",
                description: item.about ?? "-",
                memberCount: item.membersCount ?? 0,
                totalCapacity: item.capacity,
                tags: tags,
                accessType: item.visibility ?? .private,
                requestType: item.status ?? .none
            )
        }
    }

    func fetchJoinedEvents(
        query: GroupsDTOModel.PaginationQuery
    ) async throws(APIError) -> [EventsModuleModel.CardInputData] {
        let data = try await dataSource.fetchJoinedEvents(
            query: query.toDictionary()
        ).content

        return data.map { item in
            let tags: [AppUIEntities.Tags] = item.categoryResponses.map { category in
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
                totalCapacity: item.capacity,
                club: .init(name: "-", id: 0),
                tags: tags,
                bgType: .primary,
                requestType: item.requestStatus ?? .none,
                accessType: item.visibility ?? .private,
                role: item.role ?? .notJoined
            )
        }
    }
}
