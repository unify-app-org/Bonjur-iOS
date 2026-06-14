//
//  ClubRepo.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 15.05.26.
//

import AppUIKit
import Foundation
import AppNetwork
import AppStorage
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
    func editClub(
        id: Int,
        request: MultipartFormData
    ) async throws(APIError) -> Void
    func joinClub(id: Int) async throws(APIError) -> Void
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
                memberCount: item.count ?? 0,
                totalCapacity: item.capacity ?? 0,
                community: item.communityName ?? "-",
                members: members,
                bgType: item.background ?? .primary,
                accessType: item.visibility ?? .private,
                requestType: (item.joined ?? false) ? .joined : .none,
                role: item.clubUserRole
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
    
    func editClub(
        id: Int,
        request: MultipartFormData
    ) async throws(APIError) {
        let _ = try await dataSource.editClub(id: id, request: request)
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
        let logoURL = data.logoUrl.flatMap { URL(string: $0) }
        let coverURL = data.backgroundUrl.flatMap { URL(string: $0) }
        let uiModel: ClubsDetailsModel.UIModel = .init(
            name: data.name,
            communityName: data.communityName,
            membersCount: data.membersCount ?? 0,
            logo: logoURL,
            coverImage: coverURL,
            coverColorType: data.backgroundColour ?? .primary,
            userActivityType: data.clubUserRole ?? .notJoined,
            accessType: data.visibility,
            tags: tags,
            infoData: mapInfo(data),
            editPrefillData: mapPrefilData(data, tags),
            joinButton: mapButtonModel(data)
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
    
    func joinClub(
        id: Int
    ) async throws(APIError) {
        let _ = try await dataSource.joinClub(id: id)
    }
}

// MARK: - Detail Map Helper
private extension ClubRepoImpl {
    func mapButtonModel(
        _ data: ClubDTOModel.Response
    )-> ClubsDetailsModel.JoinButton? {
        let disabled = data.requestType == .pending
        let buttonTitle = switch data.requestType {
        case .joined:
            ""
        case .rejected:
            ""
        case .pending:
            "Request sent"
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
        let hasJoined = data.clubUserRole ?? .notJoined != .notJoined
        return hasJoined ? nil : joinButton
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
        info.append(
            .init(
                title: "About",
                subItems: [
                    .init(title: nil, description: data.about)
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
        return info
    }
}
