//
//  HangoutRepo.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 17.05.26.
//

import AppNetwork
import AppUIKit
import Communities
import Foundation

protocol HangoutRepo {
    func fetchHangouts(
        query: HangoutsDTOModel.PaginationQuery
    ) async throws(APIError) -> [HangoutsCardView.Model]
    
    func getCategories() async throws(APIError) -> [SelectCategoryView.Section]
    
    func createHangout(
        request: HangoutsDTOModel.Request
    ) async throws(APIError) -> Void
    
    func editHangout(
        id: String,
        request: HangoutsDTOModel.Request
    ) async throws(APIError) -> Void
    
    func fetchDetailHangout(
        id: String
    ) async throws(APIError) -> HangoutDetails.UIModel
    
    func fetchDetailHangoutMembers(
        id: String
    ) async throws(APIError) -> CommunitiesMemberModuleModel.GroupedMembersData
}

class HangoutRepoImpl: HangoutRepo {
    private let dataSource: HangoutsDataSource
    
    init(
        dataSource: HangoutsDataSource = resolve()
    ) {
        self.dataSource = dataSource
    }
    
    func fetchHangouts(
        query: HangoutsDTOModel.PaginationQuery
    ) async throws(APIError) -> [HangoutsCardView.Model] {
        let data = try await dataSource.fetchHangouts(query: query.toDictionary())
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
                description: item.about ?? "-",
                memberCount: item.membersCount ?? 0,
                totalCapacity: item.capacity,
                tags: tags,
                accessType: item.visibility ?? .private,
                requestType: .none
            )
        }
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
    
    func createHangout(
        request: HangoutsDTOModel.Request
    ) async throws(APIError) {
        let _ = try await dataSource.createHangout(request: request)
    }
    
    func editHangout(
        id: String,
        request: HangoutsDTOModel.Request
    ) async throws(APIError) {
        let _ = try await dataSource.editHangout(id: id, request: request)
    }
    
    func fetchDetailHangout(
        id: String
    ) async throws(APIError) -> HangoutDetails.UIModel {
        let data = try await dataSource.fetchHangoutsDetail(id: id)
        let tags: [AppUIEntities.Tags] = data.categories.map { category in
                .init(id: category.id, type: "", title: category.title)
        }
        var info: [HangoutDetails.Info] = []
        info.append(
            .init(
                title: "About",
                subItems: [
                    .init(title: nil, description: data.about ?? "-")
                ]
            )
        )
        let capacity = "\(0)/\(data.capacity ?? 0) members"
        info.append(
            .init(
                title: "Event info",
                subItems: [
                    .init(title: "Created/Updated Date", description: data.hangoutDate ?? "-"),
                    .init(title: "Owner Contact", description: data.ownerContact ?? "-"),
                    .init(title: "Capacity", description: capacity),
                    .init(title: "Rules", description: data.rules ?? "-"),
                    .init(title: "Location", description: data.location ?? "-")
                ]
            )
        )
        if let links = data.links, !links.isEmpty {
            let subItem: [HangoutDetails.SubInfo] = links.map { link in
                    .init(title: link.name, description: link.url ?? "-", isLink: true)
            }
            info.append(
                .init(
                    title: "Links",
                    subItems: subItem
                )
            )
        }
        let editPrefillData = HangoutsCreate.PrefillData(
            visibility: data.visibility ?? .public,
            name: data.name,
            ownerContact: data.ownerContact ?? "",
            clubName: "",
            clubOwnerContact: data.ownerContact ?? "",
            categories: tags.map { .init(id: $0.id, label: $0.title) },
            capacity: data.capacity.map(String.init) ?? "",
            links: data.links?.map {
                .init(
                    type: $0.type ?? "",
                    name: $0.name ?? "",
                    url: $0.url ?? ""
                )
            } ?? [],
            rules: data.rules ?? "",
            location: data.location ?? "",
            about: data.about ?? "",
            hangoutDate: makeDate(from: data.hangoutDate),
            endDate: nil
        )
        let uiModel: HangoutDetails.UIModel = .init(
            name: data.name,
            communityName: data.community.name,
            membersCount: 0,
            userActivityType: .member,
            accessType: data.visibility ?? .private,
            tags: tags,
            infoData: info,
            editPrefillData: editPrefillData
        )
        return uiModel
    }
    
    func fetchDetailHangoutMembers(
        id: String
    ) async throws(APIError) -> CommunitiesMemberModuleModel.GroupedMembersData {
        let data = try await dataSource.fetchMembers(id: id).content
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
    
    private func makeDate(from value: String?) -> Date? {
        guard let value else { return nil }
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [
            .withInternetDateTime,
            .withFractionalSeconds
        ]
        if let date = formatter.date(from: value) {
            return date
        }
        formatter.formatOptions = [.withInternetDateTime]
        return formatter.date(from: value)
    }
}
