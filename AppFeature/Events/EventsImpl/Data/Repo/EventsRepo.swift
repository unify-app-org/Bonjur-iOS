//
//  EventsRepo.swift
//  EventsImpl
//
//  Created by Codex on 10.06.26.
//

import AppUIKit
import Foundation
import AppNetwork
import Communities
import AppPresentationModel

protocol EventsRepo {
    func createEvent(request: MultipartFormData) async throws(APIError) -> Void
    func fetchClubsForEvents() async throws(APIError) -> [EventsCreate.SelectableClub]
    func getCategories() async throws(APIError) -> [SelectCategoryView.Section]
    func fetchEventDetail(
        eventId: String
    ) async throws(APIError) -> EventsDetailsModel.UIModel
    func fetchEventMembers(
        eventId: String
    ) async throws(APIError) -> CommunitiesMemberModuleModel.GroupedMembersData
}

final class EventsRepoImpl: EventsRepo {

    private let dataSource: EventsDataSource

    init(dataSource: EventsDataSource = resolve()) {
        self.dataSource = dataSource
    }

    func createEvent(request: MultipartFormData) async throws(APIError) {
        _ = try await dataSource.createEvent(request: request)
    }

    func fetchClubsForEvents() async throws(APIError) -> [EventsCreate.SelectableClub] {
        let data = try await dataSource.fetchClubsForEvents()
        return data.map { dto in
            EventsCreate.SelectableClub(
                clubId: dto.clubId,
                clubName: dto.clubName ?? "",
                profileURL: dto.profileUrl.flatMap { URL(string: $0) }
            )
        }
    }

    func getCategories() async throws(APIError) -> [SelectCategoryView.Section] {
        let data = try await dataSource.getCategories()
        return data.map { item in
            let categories: [CategoriesChipsView.Model] = item.subCategories.map { sub in
                .init(id: sub.id ?? 0, title: sub.title ?? "", selected: false)
            }
            return .init(
                type: item.type ?? "",
                title: item.title ?? "",
                categories: categories
            )
        }
    }

    func fetchEventDetail(
        eventId: String
    ) async throws(APIError) -> EventsDetailsModel.UIModel {
        let data = try await dataSource.fetchEventDetail(eventId: eventId)
        let tags: [AppPresentationModel.Tags] = (data.categories ?? []).map { category in
            .init(id: category.id ?? 0, type: "", title: category.title ?? "")
        }
        return .init(
            name: data.name ?? "-",
            communityName: data.club?.name ?? "-",
            membersCount: data.membersCount ?? 0,
            coverImage: data.backgroundUrl.flatMap { URL(string: $0) },
            coverColorType: .primary,
            userActivityType: data.eventUserRole ?? .notJoined,
            accessType: data.visibility ?? .private,
            tags: tags,
            infoData: mapInfo(data),
            attachments: mapAttachments(data.attachments ?? []),
            membersData: .init(users: []),
            joinButton: mapButtonModel(data)
        )
    }

    func fetchEventMembers(
        eventId: String
    ) async throws(APIError) -> CommunitiesMemberModuleModel.GroupedMembersData {
        let data = try await dataSource.fetchEventMembers(
            eventId: eventId,
            query: ["page": "0", "size": "100"]
        ).content
        let users = data.map { member in
            CommunitiesMemberModuleModel.MemberCellModel(
                id: member.userId ?? "-",
                name: member.fullName ?? "-",
                avatarURL: URL(string: member.profileUrl ?? ""),
                subtitle: "\(member.degree ?? "-"), \(member.specialization ?? "-"), \(member.entryYear ?? 0)",
                role: member.role ?? .member
            )
        }
        return .init(users: users)
    }
}

// MARK: - Detail Map Helper

private extension EventsRepoImpl {
    func mapButtonModel(
        _ data: EventDetailDTO
    ) -> EventsDetailsModel.JoinButton? {
        let role = data.eventUserRole ?? .notJoined
        guard role == .notJoined else { return nil }
        let title = data.visibility == .public ? "Join" : "Request"
        return .init(title: title, disabled: false)
    }

    func mapAttachments(_ urls: [String]) -> [AttachmentItemView.Model] {
        urls.enumerated().map { index, urlString in
            let name = URL(string: urlString)?.lastPathComponent ?? "Attachment"
            return .init(id: index, name: name, size: "")
        }
    }

    func mapInfo(_ data: EventDetailDTO) -> [EventsDetailsModel.Info] {
        var info: [EventsDetailsModel.Info] = []
        info.append(
            .init(
                title: "About",
                subItems: [
                    .init(title: nil, description: data.about ?? "-")
                ]
            )
        )
        let capacity = "\(data.membersCount ?? 0)/\(data.capacity ?? 0) members"
        info.append(
            .init(
                title: "Event info",
                subItems: [
                    .init(title: "Created/Updated Date", description: data.modifiedAt ?? "-"),
                    .init(title: "Owner Contact", description: data.ownerContact ?? "-"),
                    .init(title: "Capacity", description: capacity),
                    .init(title: "Rules", description: data.rule ?? "-"),
                    .init(title: "Location", description: data.location ?? "-")
                ]
            )
        )
        if let links = data.links, !links.isEmpty {
            let subItems: [EventsDetailsModel.SubInfo] = links.map { link in
                .init(title: link.name, description: link.url ?? "-", isLink: true)
            }
            info.append(.init(title: "Links", subItems: subItems))
        }
        return info
    }
}
