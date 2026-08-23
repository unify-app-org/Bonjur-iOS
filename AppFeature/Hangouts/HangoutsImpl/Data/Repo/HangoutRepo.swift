//
//  HangoutRepo.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 17.05.26.
//

import AppNetwork
import AppFoundation
import AppUIKit
import AppUtils
import Communities
import Foundation

protocol HangoutRepo {
    func fetchHangouts(
        query: HangoutsDTOModel.PaginationQuery
    ) async throws(APIError) -> [HangoutsCardView.Model]

    func fetchCreate() async throws(APIError) -> [HangoutsCreate.FieldSchema]

    func getCategories() async throws(APIError) -> [SelectCategoryView.Section]

    func getFilterCategories() async throws(APIError) -> [FilterView.Model]

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

    func fetchHangoutMembersPage(
        id: String,
        page: Int,
        size: Int,
        keyword: String?
    ) async throws(APIError) -> CommunitiesMemberModuleModel.MembersPage

    func exitHangout(id: String) async throws(APIError) -> Void

    func deleteHangout(id: String) async throws(APIError) -> Void

    func joinHangout(id: String) async throws(APIError) -> Void
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

            let parts = HangoutsCardView.Model.dateParts(
                from: Date.fromISO8601(item.hangoutDate)
            )

            return .init(
                id: item.id ?? "-",
                name: item.name ?? "-",
                description: item.about ?? "-",
                memberCount: item.membersCount ?? 0,
                totalCapacity: item.capacity,
                tags: tags,
                accessType: item.visibility ?? .private,
                requestType: item.requestStatus ?? .none,
                dateDay: parts.day,
                dateMonth: parts.month,
                time: parts.time,
                location: item.location,
                role: item.role
            )
        }
    }

    func fetchCreate() async throws(APIError) -> [HangoutsCreate.FieldSchema] {
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

    func getFilterCategories() async throws(APIError) -> [FilterView.Model] {
        let data = try await dataSource.getCategories()
        return data.map { item in
            let items: [FilterView.Items] = item.subCategories.map { subCategory in
                .init(
                    title: subCategory.title ?? "",
                    id: subCategory.id ?? 0
                )
            }

            return .init(
                title: item.title ?? "",
                type: item.type ?? "",
                items: items
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
        let membersCount = data.membersCount ?? 0
        var info: [HangoutDetails.Info] = []

        appendSection(&info, title: "About".localized, rows: [
            row(title: nil, value: data.about)
        ])

        appendSection(&info, title: "hangouts_info_section".localized, rows: [
            row(title: "hangouts_row_date".localized, value: meetupDate(data.hangoutDate)),
            row(title: "hangouts_row_owner_contact".localized, value: cleaned(data.ownerContact),
                phoneNumber: phoneNumber(data.ownerContact)),
            row(title: "Capacity".localized, value: capacityText(members: data.membersCount, capacity: data.capacity)),
            row(title: "Rules", value: data.rules),
            row(title: "Location", value: data.location)
        ])

        let linkRows = (data.links ?? []).map { link in
            row(title: link.name, value: link.url, isLink: true)
        }
        appendSection(&info, title: "hangouts_row_links".localized, rows: linkRows)
        let editPrefillData = HangoutsCreate.PrefillData(
            values: [
                .visibility: .radio(data.visibility ?? .public),
                .hangoutName: .text(data.name),
                .ownerContact: .text(data.ownerContact ?? ""),
                .category: .tags(tags.map { .init(id: $0.id, label: $0.title) }),
                .capacity: .text(data.capacity.map(String.init) ?? ""),
                .links: .links(data.links?.map {
                    .init(
                        type: $0.type ?? "",
                        name: $0.name ?? "",
                        url: $0.url ?? ""
                    )
                } ?? []),
                .location: .text(data.location ?? ""),
                .hangoutDate: .date(Date.fromISO8601(data.hangoutDate) ?? Date()),
                .rules: .text(data.rules ?? ""),
                .about: .text(data.about ?? "")
            ]
        )
        let uiModel: HangoutDetails.UIModel = .init(
            name: data.name,
            communityName: data.community.name,
            communityId: data.community.id,
            membersCount: membersCount,
            userActivityType: data.role ?? .notJoined,
            accessType: data.visibility ?? .private,
            tags: tags,
            infoData: info,
            editPrefillData: editPrefillData,
            joinButton: mapButtonModel(data)
        )
        return uiModel
    }

    /// Join button for the detail screen. Hidden once accepted (by role or request
    /// status); a pending request keeps a disabled "hangouts_join_request_sent".localized button visible.
    private func mapButtonModel(
        _ data: HangoutsDTOModel.HangoutDetail
    ) -> HangoutDetails.JoinButton? {
        let role = data.role ?? .notJoined
        guard role == .notJoined, data.requestStatus != .joined else { return nil }
        if data.requestStatus == .pending {
            return .init(title: "hangouts_join_request_sent".localized, disabled: true)
        }
        let title = (data.visibility ?? .private) == .public ? "hangouts_join".localized : "hangouts_request".localized
        return .init(title: title, disabled: false)
    }

    func fetchDetailHangoutMembers(
        id: String
    ) async throws(APIError) -> CommunitiesMemberModuleModel.GroupedMembersData {
        let data = try await dataSource.fetchMembers(id: id, page: 0, size: 10, keyword: nil).content
        let users = data.map(Self.mapMember)
        return .init(
            users: users,
            roleTitles: AppUIEntities.UserActivityRole
                .localizedTitles(overriding: [.president: "hangouts_owner_role".localized])
        )
    }

    func fetchHangoutMembersPage(
        id: String,
        page: Int,
        size: Int,
        keyword: String?
    ) async throws(APIError) -> CommunitiesMemberModuleModel.MembersPage {
        let response = try await dataSource.fetchMembers(id: id, page: page, size: size, keyword: keyword)
        let users = response.content.map(Self.mapMember)
        let hasMore: Bool
        if let totalPages = response.totalPages {
            hasMore = page + 1 < totalPages
        } else {
            hasMore = users.count >= size
        }
        return .init(members: users, hasMore: hasMore)
    }

    func exitHangout(id: String) async throws(APIError) {
        let _ = try await dataSource.exitHangout(id: id)
    }

    func deleteHangout(id: String) async throws(APIError) {
        let _ = try await dataSource.deleteHangout(id: id)
    }

    func joinHangout(id: String) async throws(APIError) {
        let _ = try await dataSource.joinHangout(request: .init(hangoutId: id))
    }

    private static func mapMember(
        _ member: HangoutsDTOModel.MemberResponse
    ) -> CommunitiesMemberModuleModel.MemberCellModel {
        CommunitiesMemberModuleModel.MemberCellModel(
            id: member.userId ?? "-",
            name: member.fullName ?? "-",
            avatarURL: URL(string: member.profileUrl ?? ""),
            subtitle: "\(member.degree ?? "-"), \(member.specialization ?? "-"), \(member.entryYear ?? 0)",
            role: member.role
        )
    }
}

// MARK: - Info builders

private extension HangoutRepoImpl {
    /// Trim + treat empty / `"-"` / `"None"` as absent, so empty rows are dropped.
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
    ) -> HangoutDetails.SubInfo? {
        guard let value = cleaned(value) else { return nil }
        return .init(title: title, description: value, isLink: isLink, phoneNumber: phoneNumber)
    }

    func appendSection(
        _ info: inout [HangoutDetails.Info],
        title: String,
        rows: [HangoutDetails.SubInfo?]
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

    /// Returns the contact only when it looks like a dialable phone number.
    func phoneNumber(_ value: String?) -> String? {
        guard let v = cleaned(value) else { return nil }
        let allowed = CharacterSet(charactersIn: "+0123456789 -()")
        let digits = v.filter { $0.isNumber }
        guard v.unicodeScalars.allSatisfy({ allowed.contains($0) }), digits.count >= 7 else { return nil }
        return v
    }
}
