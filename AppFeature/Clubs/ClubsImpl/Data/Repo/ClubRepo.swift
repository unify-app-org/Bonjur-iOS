//
//  ClubRepo.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 15.05.26.
//

import Foundation
import AppNetwork
import AppUIKit
import Communities

protocol ClubRepo {
    func fetchClubs(
        query: ClubDTOModel.PaginationQuery
    ) async throws(APIError) -> [ClubCardView.Model]
    func fetchCreate() async throws(APIError) -> [ClubsCreate.FieldSchema]
    func getCategories() async throws(APIError) -> [SelectCategoryView.Section]
    func createClub(request: MultipartFormData) async throws(APIError) -> Void
    func fetchClubDetails(
        clubId: Int
    ) async throws(APIError) -> ClubsDetailsModel.UIModel
    func fetchClubMemberById(id: Int) async throws(APIError) -> CommunitiesMemberModuleModel.GroupedMembersData
}

class ClubRepoImpl: ClubRepo {

    private let dataSource: ClubsDataSource

    init(
        dataSource: ClubsDataSource = resolve()
    ) {
        self.dataSource = dataSource
    }

    func fetchClubs(
        query: ClubDTOModel.PaginationQuery
    ) async throws(APIError) -> [ClubCardView.Model] {
        let data = try await dataSource.fetchClubs(query: query.toDictionary())
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
                requestType: .none
            )
        }
    }

    func fetchCreate() async throws(APIError) -> [ClubsCreate.FieldSchema] {
        try await dataSource.fetchCreate()
    }

    func getCategories() async throws(APIError) -> [SelectCategoryView.Section] {
        let data = try await dataSource.getCategories()
        return data.map { item in
            let categories: [CategoriesChipsView.Model] = item.subCategories.map { subCategory in
                .init(
                    id: subCategory.id ?? 0,
                    title: subCategory.title ?? "",
                    selected: false
                )
            }
            
            return .init(
                type: item.type ?? "",
                title: item.title ?? "",
                categories: categories
            )
        }
    }
    
    func createClub(
        request: MultipartFormData
    ) async throws(APIError) -> Void {
        let _ = try await dataSource.createClub(request: request)
    }
    
    func fetchClubDetails(clubId: Int) async throws(APIError) -> ClubsDetailsModel.UIModel {
        let data = try await dataSource.fetchClubById(id: clubId)
        let tags: [AppUIEntities.Tags] = data.categories.map { category in
                .init(id: category.id, type: "", title: category.title)
        }
        var info: [ClubsDetailsModel.Info] = []
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
            let subItem: [ClubsDetailsModel.SubInfo] = links.map { link in
                    .init(title: link.name, description: link.url, isLink: true)
            }
            info.append(
                .init(
                    title: "Links",
                    subItems: subItem
                )
            )
        }
        let uiModel: ClubsDetailsModel.UIModel = .init(
            name: data.name,
            communityName: data.communityName,
            membersCount: 0,
            logo: URL(string: "-"),
            coverImage: URL(string: "-"),
            coverColorType: .primary,
            userActivityType: .member,
            accessType: data.visibility,
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
}
