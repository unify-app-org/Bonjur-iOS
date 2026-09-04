//
//  GroupsRepo.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 26.05.26.
//

import AppNetwork
import AppUIKit
import AppUtils
import Clubs
import Events
import Foundation
import Hangouts

protocol GroupsRepo {
    func fetchJoinedClubs(
        query: GroupsDTOModel.PaginationQuery
    ) async throws(APIError) -> Page<ClubsModuleModel.CardInputData>

    func fetchJoinedHangouts(
        query: GroupsDTOModel.PaginationQuery
    ) async throws(APIError) -> Page<HangoutsModuleModel.CardInputData>

    func fetchJoinedEvents(
        query: GroupsDTOModel.PaginationQuery
    ) async throws(APIError) -> Page<EventsModuleModel.CardInputData>
}

final class GroupsRepoImpl: GroupsRepo {
    private let dataSource: GroupsDataSource
    
    init(dataSource: GroupsDataSource = resolve()) {
        self.dataSource = dataSource
    }
    
    func fetchJoinedClubs(
        query: GroupsDTOModel.PaginationQuery
    ) async throws(APIError) -> Page<ClubsModuleModel.CardInputData> {
        let response = try await dataSource.fetchJoinedClubs(
            query: query.toDictionary()
        )

        let items: [ClubsModuleModel.CardInputData] = response.content.map { item in
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
        return response.page(
            requestedPage: query.page,
            requestedSize: query.size,
            items: items
        )
    }

    func fetchJoinedHangouts(
        query: GroupsDTOModel.PaginationQuery
    ) async throws(APIError) -> Page<HangoutsModuleModel.CardInputData> {
        let response = try await dataSource.fetchJoinedHangouts(
            query: query.toDictionary()
        )

        let items: [HangoutsModuleModel.CardInputData] = response.content.map { item in
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
                requestType: item.status ?? .none,
                location: item.location,
                hangoutDate: Date.fromISO8601(item.hangoutDate),
                role: item.role
            )
        }
        return response.page(
            requestedPage: query.page,
            requestedSize: query.size,
            items: items
        )
    }

    func fetchJoinedEvents(
        query: GroupsDTOModel.PaginationQuery
    ) async throws(APIError) -> Page<EventsModuleModel.CardInputData> {
        let response = try await dataSource.fetchJoinedEvents(
            query: query.toDictionary()
        )

        let items: [EventsModuleModel.CardInputData] = response.content.map { item in
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
        return response.page(
            requestedPage: query.page,
            requestedSize: query.size,
            items: items
        )
    }
}
