//
//  ClubRepo.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 15.05.26.
//

import AppUIKit
import AppFoundation
import AppUtils
import Foundation
import AppNetwork
import AppStorage
import Communities
import AppPresentationModel

protocol ClubRepo {
    func fetchClubs(
        query: ClubDTOModel.PaginationQuery
    ) async throws(APIError) -> [ClubCardView.Model]
    func fetchCreate() async throws(APIError) -> [ClubsCreate.FieldSchema]
    func getCategories() async throws(APIError) -> [SelectCategoryView.Section]
    func getFilterCategories() async throws(APIError) -> [FilterView.Model]
    func createClub(request: MultipartFormData) async throws(APIError) -> Int?
    func fetchClubDetails(
        clubId: Int
    ) async throws(APIError) -> ClubsDetailsModel.UIModel
    func fetchClubMemberById(id: Int) async throws(APIError) -> CommunitiesMemberModuleModel.GroupedMembersData
    func fetchClubMembersPage(
        id: Int,
        page: Int,
        size: Int,
        keyword: String?
    ) async throws(APIError) -> CommunitiesMemberModuleModel.MembersPage
    func editClub(
        id: Int,
        request: MultipartFormData
    ) async throws(APIError) -> Void
    func joinClub(id: Int) async throws(APIError) -> Void
    func assignRole(
        clubId: Int,
        userId: String,
        role: AppPresentationModel.UserActivityRole
    ) async throws(APIError) -> Void
    func exitClub(id: Int) async throws(APIError) -> Void
    func clubHasVicePresident(id: Int) async throws(APIError) -> Bool
    func requestVerify(id: Int) async throws(APIError) -> Void
}

class ClubRepoImpl: ClubRepo {

    private let dataSource: ClubsDataSource
    private let userDefaults: UserDefaultsProtocol
    
    init(
        dataSource: ClubsDataSource = resolve(),
        userDefaults: UserDefaultsProtocol = resolve()
    ) {
        self.dataSource = dataSource
        self.userDefaults = userDefaults
    }

    func fetchClubs(
        query: ClubDTOModel.PaginationQuery
    ) async throws(APIError) -> [ClubCardView.Model] {
        var dict = query.toDictionary()
        dict["parentId"] = String(userDefaults.integer(forKey: .communityId))
        let data = try await dataSource.fetchClubs(query: dict)
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
                memberCount: item.memberCount ?? 0,
                totalCapacity: item.capacity ?? 0,
                community: item.communityName ?? "-",
                members: members,
                bgType: item.background ?? .primary,
                accessType: item.visibility ?? .private,
                requestType: item.requestStatus ?? .none,
                role: item.role,
                upcomingEventsCount: item.eventCount ?? 0,
                categories: (item.categoryResponses ?? []).map { $0.title },
                isVerified: item.clubStatus?.isVerified ?? false
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

    func editClub(
        id: Int,
        request: MultipartFormData
    ) async throws(APIError) {
        let _ = try await dataSource.editClub(id: id, request: request)
    }
    
    func createClub(
        request: MultipartFormData
    ) async throws(APIError) -> Int? {
        let data = try await dataSource.createClub(request: request)
        return try? JSONDecoder().decode(ClubDTOModel.CreateResponse.self, from: data).id
    }

    func requestVerify(id: Int) async throws(APIError) -> Void {
        _ = try await dataSource.requestVerify(id: id)
    }

    func fetchClubDetails(clubId: Int) async throws(APIError) -> ClubsDetailsModel.UIModel {
        let data = try await dataSource.fetchClubById(id: clubId)
        let tags: [AppUIEntities.Tags] = data.categories.map { category in
                .init(id: category.id, type: "", title: category.title)
        }
        let logoURL = data.logoUrl.flatMap { URL(string: $0) }
        let coverURL = data.backgroundUrl.flatMap { URL(string: $0) }
        let uiModel: ClubsDetailsModel.UIModel = .init(
            name: data.name,
            communityName: data.communityName,
            membersCount: data.membersCount ?? 0,
            eventsCount: data.eventCount,
            clubsCount: data.clubCount,
            logo: logoURL,
            coverImage: coverURL,
            coverColorType: data.backgroundColour ?? .primary,
            userActivityType: data.clubUserRole ?? .notJoined,
            accessType: data.visibility,
            tags: tags,
            infoData: mapInfo(data),
            editPrefillData: mapPrefilData(data, tags),
            joinButton: mapButtonModel(data),
            clubStatus: data.status
        )
        return uiModel
    }
    
    func fetchClubMemberById(
        id: Int
    ) async throws(APIError) -> CommunitiesMemberModuleModel.GroupedMembersData {
        let data = try await dataSource.fetchClubMemberById(id: id, page: 0, size: 10, keyword: nil).content
        let users = data.map(Self.mapMember)
        return .init(users: users)
    }

    func fetchClubMembersPage(
        id: Int,
        page: Int,
        size: Int,
        keyword: String?
    ) async throws(APIError) -> CommunitiesMemberModuleModel.MembersPage {
        let response = try await dataSource.fetchClubMemberById(id: id, page: page, size: size, keyword: keyword)
        let users = response.content.map(Self.mapMember)
        return .init(members: users, hasMore: response.hasMore)
    }

    private static func mapMember(
        _ member: ClubDTOModel.MemberResponse.Member
    ) -> CommunitiesMemberModuleModel.MemberCellModel {
        CommunitiesMemberModuleModel.MemberCellModel(
            id: member.userId ?? "-",
            name: member.fullName ?? "-",
            avatarURL: URL(string: member.profileUrl ?? ""),
            subtitle: "\(member.degree ?? "-"), \(member.specialization ?? "-"), \(member.entryYear ?? 0)",
            role: member.role
        )
    }

    func joinClub(
        id: Int
    ) async throws(APIError) {
        let _ = try await dataSource.joinClub(id: id)
    }

    func assignRole(
        clubId: Int,
        userId: String,
        role: AppPresentationModel.UserActivityRole
    ) async throws(APIError) {
        let _ = try await dataSource.assignRole(
            id: clubId,
            request: .init(userId: userId, role: role)
        )
    }

    func exitClub(id: Int) async throws(APIError) {
        let _ = try await dataSource.exitClub(id: id)
    }

    func clubHasVicePresident(id: Int) async throws(APIError) -> Bool {
        let pageSize = 50
        var page = 0
        while true {
            let content = try await dataSource
                .fetchClubMemberById(id: id, page: page, size: pageSize, keyword: nil)
                .content
            if content.contains(where: { $0.role == .visePresident }) {
                return true
            }
            guard content.count >= pageSize else { return false }
            page += 1
        }
    }
}

// MARK: - Detail Map Helper
private extension ClubRepoImpl {
    func mapButtonModel(
        _ data: ClubDTOModel.Response
    )-> ClubsDetailsModel.JoinButton? {
        let disabled = data.clubUserStatus == .pending
        let buttonTitle = switch data.clubUserStatus {
        case .joined:
            ""
        case .rejected:
            "Request"
        case .pending:
            "clubs_join_request_sent".localized
        default:
            switch data.visibility {
            case .public:
                "Join"
            case .private:
                "Request"
            }
        }
        let joinButton: ClubsDetailsModel.JoinButton = .init(
            title: buttonTitle,
            disabled: disabled
        )
        return data.clubUserStatus == .joined ? nil : joinButton
    }
    
    func mapPrefilData(
        _ data: ClubDTOModel.Response,
        _ tags: [AppUIEntities.Tags]
    ) -> ClubsCreate.PrefillData {
        let logoURL = data.logoUrl.flatMap { URL(string: $0) }
        let coverURL = data.backgroundUrl.flatMap { URL(string: $0) }
        let editPrefillData = ClubsCreate.PrefillData(
            logoURL: logoURL,
            coverURL: coverURL,
            values: [
                .cover: .cover(data.backgroundColour ?? .primary),
                .visibility: .radio(data.visibility),
                .clubName: .text(data.name),
                .ownerContact: .text(data.ownerContact ?? ""),
                .category: .tags(tags.map { .init(id: $0.id, label: $0.title) }),
                .capacity: .text(data.capacity.map(String.init) ?? ""),
                .links: .links(data.links?.map {
                    .init(type: $0.type, name: $0.name, url: $0.url)
                } ?? []),
                .location: .text(data.location ?? ""),
                .rules: .text(data.rule ?? ""),
                .about: .text(data.about)
            ]
        )
        return editPrefillData
    }
    
    func mapInfo(
        _ data: ClubDTOModel.Response
    ) -> [ClubsDetailsModel.Info] {
        var info: [ClubsDetailsModel.Info] = []

        appendSection(&info, title: "About".localized, rows: [
            row(title: nil, value: data.about)
        ])

        appendSection(&info, title: "clubs_info_section".localized, rows: [
            row(title: "Created/Updated Date".localized, value: modifiedDate(data.modifiedAt)),
            row(title: "clubs_row_owner_contact".localized, value: cleaned(data.ownerContact),
                phoneNumber: phoneNumber(data.ownerContact)),
            row(title: "Capacity".localized, value: capacityText(members: data.membersCount, capacity: data.capacity)),
            row(title: "Rules", value: data.rule),
            row(title: "Location", value: data.location)
        ])

        let linkRows = (data.links ?? []).map { link in
            row(title: link.name, value: link.url, isLink: true)
        }
        appendSection(&info, title: "clubs_row_links".localized, rows: linkRows)

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
    ) -> ClubsDetailsModel.SubInfo? {
        guard let value = cleaned(value) else { return nil }
        return .init(title: title, description: value, isLink: isLink, phoneNumber: phoneNumber)
    }

    func appendSection(
        _ info: inout [ClubsDetailsModel.Info],
        title: String,
        rows: [ClubsDetailsModel.SubInfo?]
    ) {
        let items = rows.compactMap { $0 }
        guard !items.isEmpty else { return }
        info.append(.init(title: title, subItems: items))
    }

    func capacityText(members: Int?, capacity: Int?) -> String? {
        guard let capacity, capacity > 0 else { return nil }
        return "\(members ?? 0)/\(capacity) members"
    }

    func modifiedDate(_ value: String?) -> String? {
        guard let v = cleaned(value) else { return nil }
        let formatted = v.date(from: .ddMMyyyyHHmmss, to: .dMMMMYYYY)
        return formatted.isEmpty ? v : formatted
    }

    func phoneNumber(_ value: String?) -> String? {
        guard let v = cleaned(value) else { return nil }
        let allowed = CharacterSet(charactersIn: "+0123456789 -()")
        let digits = v.filter { $0.isNumber }
        guard v.unicodeScalars.allSatisfy({ allowed.contains($0) }), digits.count >= 7 else { return nil }
        return v
    }
}
