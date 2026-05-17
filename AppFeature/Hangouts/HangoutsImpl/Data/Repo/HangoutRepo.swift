//
//  HangoutRepo.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 17.05.26.
//

import AppNetwork
import AppUIKit
import Communities

protocol HangoutRepo {
    func fetchHangouts(
        query: HangoutsDTOModel.PaginationQuery
    ) async throws(APIError) -> [HangoutsCardView.Model]
    
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
                    .init(title: "Owner Contact", description: "-"),
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
        let uiModel: HangoutDetails.UIModel = .init(
            name: data.name,
            communityName: data.community.name,
            membersCount: 0,
            userActivityType: .member,
            accessType: data.visibility ?? .private,
            tags: tags,
            infoData: info
        )
        return uiModel
    }
    
    func fetchDetailHangoutMembers(
        id: String
    ) async throws(APIError) -> CommunitiesMemberModuleModel.GroupedMembersData {
        .mockData
    }
}
