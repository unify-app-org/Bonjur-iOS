//
//  EventsRepo.swift
//  EventsImpl
//
//  Created by Codex on 10.06.26.
//

import Events
import AppUIKit
import AppUtils
import Foundation
import AppNetwork
import Communities
import AppPresentationModel

protocol EventsRepo {
    func fetchEvents(
        categoryIds: [Int],
        keyword: String?,
        page: Int,
        size: Int
    ) async throws(APIError) -> [EventsModuleModel.CardInputData]
    func fetchClubEvents(
        clubId: Int,
        page: Int,
        size: Int
    ) async throws(APIError) -> [EventsModuleModel.CardInputData]
    func joinEvent(eventId: String) async throws(APIError) -> Void
    func exitEvent(eventId: String) async throws(APIError) -> Void
    func createEvent(request: MultipartFormData) async throws(APIError) -> Void
    func editEvent(eventId: String, request: MultipartFormData) async throws(APIError) -> Void
    func fetchClubsForEvents() async throws(APIError) -> [EventsCreate.SelectableClub]
    func getCategories() async throws(APIError) -> [SelectCategoryView.Section]
    func getFilterCategories() async throws(APIError) -> [FilterView.Model]
    func fetchEventDetail(
        eventId: String
    ) async throws(APIError) -> EventsDetailsModel.UIModel
    func fetchEventMembers(
        eventId: String
    ) async throws(APIError) -> CommunitiesMemberModuleModel.GroupedMembersData
    func fetchEventMembersPage(
        eventId: String,
        page: Int,
        size: Int,
        keyword: String?
    ) async throws(APIError) -> CommunitiesMemberModuleModel.MembersPage
}

final class EventsRepoImpl: EventsRepo {

    private let dataSource: EventsDataSource

    init(dataSource: EventsDataSource = resolve()) {
        self.dataSource = dataSource
    }

    func fetchEvents(
        categoryIds: [Int],
        keyword: String?,
        page: Int,
        size: Int
    ) async throws(APIError) -> [EventsModuleModel.CardInputData] {
        var query = ["page": "\(page)", "size": "\(size)"]
        if !categoryIds.isEmpty {
            query["categoryIds"] = categoryIds.map(String.init).joined(separator: ",")
        }
        if let keyword, !keyword.isEmpty {
            query["keyword"] = keyword
        }
        let data = try await dataSource.fetchDiscoverEvents(
            query: query
        )
        return data.map(Self.mapCard)
    }

    /// Active events for a single club (GET api/es/v1/events/{clubId}/events).
    /// Paged response shares the discover `EventDiscoverDTO` shape, so reuse `mapCard`.
    func fetchClubEvents(
        clubId: Int,
        page: Int,
        size: Int
    ) async throws(APIError) -> [EventsModuleModel.CardInputData] {
        let query = ["page": "\(page)", "size": "\(size)"]
        let response = try await dataSource.fetchClubEvents(clubId: clubId, query: query)
        return response.content.map(Self.mapCard)
    }

    private static func mapCard(
        _ item: EventDiscoverDTO
    ) -> EventsModuleModel.CardInputData {
        let tags: [AppPresentationModel.Tags] = item.categoryResponses.map { category in
            .init(id: category.id ?? 0, type: "", title: category.title ?? "-")
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

    func joinEvent(eventId: String) async throws(APIError) {
        _ = try await dataSource.joinEvent(eventId: eventId)
    }

    func exitEvent(eventId: String) async throws(APIError) {
        _ = try await dataSource.exitEvent(eventId: eventId)
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

    func getFilterCategories() async throws(APIError) -> [FilterView.Model] {
        let data = try await dataSource.getCategories()
        return data.map { item in
            let items: [FilterView.Items] = item.subCategories.map { sub in
                .init(
                    title: sub.title ?? "",
                    id: sub.id ?? 0
                )
            }
            return .init(
                title: item.title ?? "",
                type: item.type ?? "",
                items: items
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
            clubId: data.club?.id ?? 0,
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
        let users = data.map(Self.mapMember)
        return .init(users: users, titleOverrides: [.president: "Owner"])
    }

    func fetchEventMembersPage(
        eventId: String,
        page: Int,
        size: Int,
        keyword: String?
    ) async throws(APIError) -> CommunitiesMemberModuleModel.MembersPage {
        var query = ["page": "\(page)", "size": "\(size)"]
        if let keyword, !keyword.isEmpty { query["keyword"] = keyword }
        let response = try await dataSource.fetchEventMembers(
            eventId: eventId,
            query: query
        )
        let users = response.content.map(Self.mapMember)
        let hasMore: Bool
        if let totalPages = response.totalPages {
            hasMore = page + 1 < totalPages
        } else {
            hasMore = users.count >= size
        }
        return .init(members: users, hasMore: hasMore)
    }

    private static func mapMember(
        _ member: EventMembersResponse.Member
    ) -> CommunitiesMemberModuleModel.MemberCellModel {
        CommunitiesMemberModuleModel.MemberCellModel(
            id: member.userId ?? "-",
            name: member.fullName ?? "-",
            avatarURL: URL(string: member.profileUrl ?? ""),
            subtitle: "\(member.degree ?? "-"), \(member.specialization ?? "-"), \(member.entryYear ?? 0)",
            role: member.role ?? .member
        )
    }
}

// MARK: - Detail Map Helper

private extension EventsRepoImpl {
    func mapButtonModel(
        _ data: EventDetailDTO
    ) -> EventsDetailsModel.JoinButton? {
        // Hide once accepted (by role or request status).
        let role = data.eventUserRole ?? .notJoined
        guard role == .notJoined, data.requestStatus != .joined else { return nil }
        // A pending request keeps a disabled "Request sent" button visible.
        if data.requestStatus == .pending {
            return .init(title: "Request sent", disabled: true)
        }
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
                .rules: .text(data.rule ?? ""),
                .reminder: .reminders(data.reminderTimes ?? [])
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

        appendSection(&info, title: "About", rows: [
            row(title: nil, value: data.about)
        ])

        var eventRows: [EventsDetailsModel.SubInfo?] = [
            row(title: "Date", value: meetupDate(data.eventDate)),
            row(title: "Created/Updated Date", value: modifiedDate(data.modifiedAt)),
            row(title: "Owner Contact", value: cleaned(data.ownerContact),
                phoneNumber: phoneNumber(data.ownerContact)),
            row(title: "Capacity", value: capacityText(members: data.membersCount, capacity: data.capacity)),
            row(title: "Rules", value: data.rule),
            row(title: "Location", value: data.location)
        ]
        // Reminders are an organiser broadcast config — only organisers see them.
        if isOrganizer(data.eventUserRole), let reminders = reminderText(data.reminderTimes) {
            eventRows.append(row(title: "Reminders", value: reminders))
        }
        appendSection(&info, title: "Event info", rows: eventRows)

        let linkRows = (data.links ?? []).map { link in
            row(title: link.name, value: link.url, isLink: true)
        }
        appendSection(&info, title: "Links", rows: linkRows)

        return info
    }

    // MARK: - Info builders
    
    func cleaned(_ value: String?) -> String? {
        guard let v = value?.trimmingCharacters(in: .whitespacesAndNewlines),
              !v.isEmpty, v != "-", v.lowercased() != "none" else { return nil }
        return v
    }

    func row(
        title: String?,
        value: String?,
        isLink: Bool = false,
        phoneNumber: String? = nil
    ) -> EventsDetailsModel.SubInfo? {
        guard let value = cleaned(value) else { return nil }
        return .init(title: title, description: value, isLink: isLink, phoneNumber: phoneNumber)
    }

    func appendSection(
        _ info: inout [EventsDetailsModel.Info],
        title: String,
        rows: [EventsDetailsModel.SubInfo?]
    ) {
        let items = rows.compactMap { $0 }
        guard !items.isEmpty else { return }
        info.append(.init(title: title, subItems: items))
    }

    func capacityText(members: Int?, capacity: Int?) -> String? {
        guard let capacity, capacity > 0 else { return nil }
        return "\(members ?? 0)/\(capacity) members"
    }

    /// Meetup date+time, rendered in device-local time.
    func meetupDate(_ iso: String?) -> String? {
        guard let date = Date.fromISO8601(iso) else { return nil }
        return date.toString(format: .dMMMMyyyyHHmm)
    }

    /// `dd-MM-yyyy HH:mm:ss` audit stamp → date-only display.
    func modifiedDate(_ value: String?) -> String? {
        guard let v = cleaned(value) else { return nil }
        let formatted = v.date(from: .ddMMyyyyHHmmss, to: .dMMMMYYYY)
        return formatted.isEmpty ? v : formatted
    }

    /// Returns the contact only when it looks like a dialable phone number.
    func phoneNumber(_ value: String?) -> String? {
        guard let v = cleaned(value) else { return nil }
        let allowed = CharacterSet(charactersIn: "+0123456789 -()")
        let digits = v.filter { $0.isNumber }
        guard v.unicodeScalars.allSatisfy({ allowed.contains($0) }), digits.count >= 7 else { return nil }
        return v
    }

    func isOrganizer(_ role: AppPresentationModel.UserActivityRole?) -> Bool {
        guard let role else { return false }
        return [.president, .visePresident, .eventCreator].contains(role)
    }

    func reminderText(_ values: [AppPresentationModel.ReminderOption]?) -> String? {
        guard let values, !values.isEmpty else { return nil }
        return values.map{ item in
            item.label
        }.joined(separator: ", ")
    }
}
