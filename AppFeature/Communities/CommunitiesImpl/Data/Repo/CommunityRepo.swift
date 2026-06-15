//
//  CommunityRepo.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 16.05.26.
//

import Foundation
import Clubs
import AppUtils
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
        communityId: Int,
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

        appendSection(&info, title: "About", rows: [
            row(title: nil, value: data.about)
        ])

        appendSection(&info, title: "Event info", rows: [
            row(title: "Created/Updated Date", value: modifiedDate(data.modifiedAt)),
            row(title: "Owner Contact", value: cleaned(data.ownerContact),
                phoneNumber: phoneNumber(data.ownerContact)),
            row(title: "Capacity", value: capacityText(members: data.membersCount, capacity: data.capacity)),
            row(title: "Rules", value: data.rule),
            row(title: "Location", value: data.location)
        ])

        let linkRows = (data.links ?? []).map { link in
            row(title: link.name, value: link.url, isLink: true)
        }
        appendSection(&info, title: "Links", rows: linkRows)
        let logoURL = data.logoUrl.flatMap { URL(string: $0) }
        let coverURL = data.backgroundUrl.flatMap { URL(string: $0) }
        let editPrefillData = ClubsModuleModel.CreatePrefillData(
            logoURL: logoURL,
            coverURL: coverURL,
            coverType: data.backgroundColour ?? .primary,
            visibility: data.visibility ?? .public,
            name: data.name,
            ownerContact: data.ownerContact,
            categories: tags.map {
                .init(id: $0.id, title: $0.title)
            },
            capacity: data.capacity.map(String.init) ?? "",
            links: data.links?.map {
                .init(type: $0.type, name: $0.name, url: $0.url)
            } ?? [],
            location: data.location ?? "",
            rules: data.rule ?? "",
            about: data.about
        )
        let uiModel: CommunityDetails.UIModel = .init(
            name: data.name,
            membersCount: data.membersCount ?? 0,
            logo: logoURL,
            coverImage: coverURL,
            coverColorType: data.backgroundColour ?? .primary,
            userActivity: data.clubUserRole ?? .notJoined,
            tags: tags,
            infoData: info,
            editPrefillData: editPrefillData
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
        communityId: Int,
        query: CommunityDTO.PaginationQuery
    ) async throws(APIError) -> [ClubsModuleModel.CardInputData] {
        var dict = query.toDictionary()
        dict["parentId"] = "\(communityId)"
        let data = try await dataSource.getClubs(
            query: dict
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
                    requestType: .none,
                    role: item.role ?? .notJoined
                )
        }
        return uiModel
    }
}

// MARK: - Info builders

private extension CommunityRepoImpl {
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
    ) -> CommunityDetails.SubInfo? {
        guard let value = cleaned(value) else { return nil }
        return .init(title: title, description: value, isLink: isLink, phoneNumber: phoneNumber)
    }

    func appendSection(
        _ info: inout [CommunityDetails.Info],
        title: String,
        rows: [CommunityDetails.SubInfo?]
    ) {
        let items = rows.compactMap { $0 }
        guard !items.isEmpty else { return }
        info.append(.init(title: title, subItems: items))
    }

    func capacityText(members: Int?, capacity: Int?) -> String? {
        guard let capacity, capacity > 0 else { return nil }
        return "\(members ?? 0)/\(capacity) members"
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
}

