//
//  CommunityRepo.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 16.05.26.
//

import Foundation
import Clubs
import AppPresentationModel
import AppNetwork
import AppUIKit
import Communities

protocol CommunityRepo {
    func fetchClubById(
        id: Int
    ) async throws(APIError) -> CommunityDetails.UIModel
    
    func fetchClubMemberById(
        id: Int
    ) async throws(APIError) -> CommunitiesMemberModuleModel.GroupedMembersData
    
    func getClubs(
        query: CommunityDTO.PaginationQuery
    ) async throws(APIError) -> [ClubsModuleModel.CardInputData]
}

class CommunityRepoImpl: CommunityRepo {
    private let dataSource: CommunityDataSource
    
    init(
        dataSource: CommunityDataSource = resolve()
    ) {
        self.dataSource = dataSource
    }
    
    func fetchClubById(
        id: Int
    ) async throws(APIError) -> CommunityDetails.UIModel {
        let data = try await dataSource.fetchClubById(id: id)
        let tags: [AppUIEntities.Tags] = data.categories.map { category in
                .init(id: category.id, type: "", title: category.title)
        }
        var info: [CommunityDetails.Info] = []
        info.append(
            .init(
                title: "About",
                subItems: [
                    .init(title: nil, description: data.about)
                ]
            )
        )
        let capacity = "\(2)/\(data.capacity ?? 0) members"
        info.append(
            .init(
                title: "Event info",
                subItems: [
                    .init(title: "Created/Updated Date", description: "-"),
                    .init(title: "Owner Contact", description: data.ownerContact),
                    .init(title: "Capacity", description: capacity),
                    .init(title: "Rules", description: data.rule ?? "-"),
                    .init(title: "Location", description: data.location ?? "-")
                ]
            )
        )
        if let links = data.links, !links.isEmpty {
            let subItem: [CommunityDetails.SubInfo] = links.map { link in
                    .init(title: link.name, description: link.url, isLink: true)
            }
            info.append(
                .init(
                    title: "Links",
                    subItems: subItem
                )
            )
        }
        let uiModel: CommunityDetails.UIModel = .init(
            name: data.name,
            membersCount: data.capacity ?? 0,
            logo: URL(string: ""),
            coverImage: URL(string: ""),
            coverColorType: .primary,
            tags: tags,
            infoData: info
        )
        return uiModel
    }

    func fetchClubMemberById(
        id: Int
    ) async throws(APIError) -> CommunitiesMemberModuleModel.GroupedMembersData {
        let data = try await dataSource.fetchClubMemberById(id: id).content
        let users = data.map { member in
            CommunitiesMemberModuleModel.MemberCellModel(
                id: member.userId ?? "-",
                name: member.fullName ?? "-",
                avatarURL: URL(string: member.profileUrl ?? ""),
                subtitle: "\(member.degree ?? "-"), \(member.specialization ?? "-"), \(member.entryYear ?? 0)",
                role: member.role
            )
        }
        return .init(users: users)
    }
    
    func getClubs(
        query: CommunityDTO.PaginationQuery
    ) async throws(APIError) -> [ClubsModuleModel.CardInputData] {
        let data = try await dataSource.getClubs(
            query: query.toDictionary()
        )
        let uiModel: [ClubsModuleModel.CardInputData] = data.map { item in
            let members: [AppPresentationModel.Member] = item.members?.map { member in
                AppPresentationModel.Member(
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
}
