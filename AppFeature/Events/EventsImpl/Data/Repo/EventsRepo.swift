//
//  EventsRepo.swift
//  EventsImpl
//
//  Created by Codex on 10.06.26.
//

import Events
import AppUIKit
import Foundation
import AppNetwork
import Communities
import AppPresentationModel

protocol EventsRepo {
    func fetchEvents() async throws(APIError) -> [EventsModuleModel.CardInputData]
    func joinEvent(eventId: String) async throws(APIError) -> Void
    func createEvent(request: MultipartFormData) async throws(APIError) -> Void
    func editEvent(eventId: String, request: MultipartFormData) async throws(APIError) -> Void
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

    func fetchEvents() async throws(APIError) -> [EventsModuleModel.CardInputData] {
        let data = try await dataSource.fetchDiscoverEvents(
            query: ["page": "0", "size": "50"]
        )
        return data.map { item in
            let tags: [AppPresentationModel.Tags] = item.categoryResponses.map { category in
                .init(id: category.id ?? 0, type: "", title: category.title ?? "-")
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

    func joinEvent(eventId: String) async throws(APIError) {
        _ = try await dataSource.joinEvent(eventId: eventId)
    }

    func createEvent(request: MultipartFormData) async throws(APIError) {
        _ = try await dataSource.createEvent(request: request)
    }

    func editEvent(eventId: String, request: MultipartFormData) async throws(APIError) {
        _ = try await dataSource.editEvent(eventId: eventId, request: request)
    }

    func fetchClubsForEvents() async throws(APIError) -> [EventsCreate.SelectableClub] {
        let data = try await dataSource.fetchClubsForEvents().content
        return data.map { dto in
            EventsCreate.SelectableClub(
                clubId: dto.id,
                clubName: dto.name ?? "",
                profileURL: dto.clubProfile.flatMap { URL(string: $0) },
                backgroundURL: dto.backgroundUrl.flatMap { URL(string: $0) },
                role: dto.role ?? .member,
                background: dto.background ?? .primary
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
            joinButton: mapButtonModel(data),
            editPrefillData: mapPrefillData(data, tags)
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

    /// Build edit-mode prefill from the detail DTO. Mirrors `ClubRepoImpl.mapPrefilData`.
    /// Note: `eventDate`/`reminder` are not returned by the detail endpoint, so the
    /// create-form defaults stay. Existing attachments arrive as remote URLs; they are
    /// re-uploaded on save by `EventCreateViewModel.buildMultipart` (it re-downloads them).
    func mapPrefillData(
        _ data: EventDetailDTO,
        _ tags: [AppPresentationModel.Tags]
    ) -> EventsCreate.PrefillData {
        let attachments: [AppFieldSchema.AttachmentItem] = (data.attachments ?? []).compactMap { attachment in
            guard let url = URL(string: attachment.url ?? "") else { return nil }
            return .init(name: attachment.name ?? "", url: url, size: attachment.size ?? "")
        }
        return EventsCreate.PrefillData(
            selectedClubId: data.club?.id ?? 0,
            values: [
                .visibility: .radio(data.visibility ?? .private),
                .eventName: .text(data.name ?? ""),
                .ownerContact: .text(data.ownerContact ?? ""),
                .about: .text(data.about ?? ""),
                .category: .tags(tags.map { .init(id: $0.id, label: $0.title) }),
                .location: .text(data.location ?? ""),
                .capacity: .text(data.capacity.map(String.init) ?? ""),
                .links: .links((data.links ?? []).map {
                    .init(type: $0.type ?? "", name: $0.name ?? "", url: $0.url ?? "")
                }),
                .attachment: .attachments(attachments),
                .rules: .text(data.rule ?? "")
            ]
        )
    }

    func mapAttachments(_ urls: [EventDetailDTO.Attachments]) -> [AttachmentItemView.Model] {
        urls.enumerated().map { index, attachment in
            return .init(id: index, name: attachment.name ?? "", size: attachment.size ?? "")
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
