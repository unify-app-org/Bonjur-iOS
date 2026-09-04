//
//  ProfileRepo.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 11.05.26.
//

import AppUIKit
import AppUtils
import AppNetwork
import AppStorage
import Foundation
import Clubs
import Events
import Hangouts
import AppPresentationModel

protocol ProfileRepo {
    /// [communityId] scopes the lookup; nil falls back to the community stored at login.
    func getUsers(userId: String?, communityId: Int?) async throws(APIError) -> ProfileDetail.UIModel
    func getCategories() async throws(APIError) -> [SelectCategoryView.Section]
    func getLanguages() async throws(APIError) -> [SelectableListItemView.Model]
    func deleteAccount() async throws(APIError) -> Data
    func editProfile(
        multiPart: MultipartFormData?,
        queryData: ProfileDTOModel.UpdateRequest?
    ) async throws(APIError) -> Data
    func fetchSections(
        notificationsEnabled: Bool
    ) -> [ProfileSettingsViewState.SettingsSection]
    func getMyClubs(
        userId: String?,
        page: Int,
        size: Int
    ) async throws(APIError) -> Page<ClubsModuleModel.CardInputData>
    func getMyHangouts(
        userId: String?,
        page: Int,
        size: Int
    ) async throws(APIError) -> Page<HangoutsModuleModel.CardInputData>
    func getMyEvents(
        page: Int,
        size: Int
    ) async throws(APIError) -> Page<EventsModuleModel.CardInputData>
}

class ProfileRepoImpl: ProfileRepo {
    
    private let dataSource: ProfileDataSource
    private let tokenManager: TokenManager
    private let userDefaults: UserDefaultsProtocol
    
    init(
        dataSource: ProfileDataSource = resolve(),
        tokenManager: TokenManager = resolve(),
        userDefaults: UserDefaultsProtocol = resolve()
    ) {
        self.dataSource = dataSource
        self.tokenManager = tokenManager
        self.userDefaults = userDefaults
    }
    
    func getUsers(userId: String?, communityId: Int?) async throws(APIError) -> ProfileDetail.UIModel {
        let fallbackId = await tokenManager.getUserId()
        let data = try await dataSource.fetchProfile(
            userId: userId ?? fallbackId,
            // Every context except a community detail uses the community picked at login.
            clubId: communityId ?? userDefaults.integer(forKey: .communityId)
        )
        let userCardModel: UserCardModel = .init(
            backgroundCover: data.background,
            nameSurname: data.fullName ?? "-",
            speciality: data.specialization ?? "-",
            course: Self.yearText(data.year),
            community: data.communityName ?? "-",
            degree: data.degree ?? "-",
            entryYear: String(data.entryYear ?? 2000),
            email: data.mail ?? "",
            imageUrl: URL(string: data.fileUrl ?? "")
        )
        let languages: [SelectableListItemView.Model] = data.languages?.map { item in
            SelectableListItemView.Model(
                id: item.id ?? 0,
                title: item.name ?? "-",
                selected: false
            )
        } ?? []
        let tags: [AppUIEntities.Tags] = data.categories?.map { item in
                .init(
                    id: item.id ?? 0,
                    type: "",
                    title: item.title ?? "-"
                )
        } ?? []
        let gender = AppPresentationModel.GenderModel(
            type: data.gender ?? .male,
            title: AppPresentationModel.GenderModel.title(
                for: data.gender?.rawValue ?? ""
            )
        )
        let uiModel: ProfileDetail.UIModel = .init(
            userCardModel: userCardModel,
            about: data.about,
            gender: gender,
            birthday: data.birthDate,
            languages: languages,
            tags: tags
        )
        return uiModel
    }

    private func makeURL(from value: String?) -> URL? {
        guard let value, !value.isEmpty else {
            return nil
        }
        return URL(string: value)
    }

    /// Academic year of study → "4th year". `nil`/0 → "-".
    private static func yearText(_ year: Int?) -> String {
        guard let year, year > 0 else { return "-" }
        let suffix: String
        switch year {
        case 1: suffix = "st"
        case 2: suffix = "nd"
        case 3: suffix = "rd"
        default: suffix = "th"
        }
        return "\(year)\(suffix) year"
    }

    func editProfile(
        multiPart: MultipartFormData?,
        queryData: ProfileDTOModel.UpdateRequest?
    ) async throws(APIError) -> Data {
        try await dataSource.editProfile(
            multiPart: multiPart,
            queryData: queryData?.toDictionary()
        )
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
    
    func getLanguages() async throws(APIError) -> [SelectableListItemView.Model] {
        let data = try await dataSource.getLanguages()
        return data.map { item in
            .init(
                id: item.id,
                title: item.name ?? "",
                selected: false,
                style: .multySelect
            )
        }
    }
    
    func deleteAccount() async throws(APIError) -> Data {
        try await dataSource.deleteAccount()
    }
    
    func fetchSections(
        notificationsEnabled: Bool
    ) -> [ProfileSettingsViewState.SettingsSection] {
        dataSource.fetchSections(notificationsEnabled: notificationsEnabled)
    }
    
    func getMyClubs(
        userId: String?,
        page: Int,
        size: Int
    ) async throws(APIError) -> Page<ClubsModuleModel.CardInputData> {
        let myUserId = await tokenManager.getUserId()
        let userId = userId ?? myUserId
        let response = try await dataSource.getMyClubs(userID: userId, page: page, size: size)
        let items: [ClubsModuleModel.CardInputData] = response.content.map { item in
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
                role: item.role ?? .notJoined,
                upcomingEventsCount: item.eventCount ?? 0,
                categories: (item.categoryResponses ?? []).map {
                    .init(id: $0.id ?? 0, title: $0.title ?? "-")
                },
                isVerified: item.clubStatus?.isVerified ?? false
            )
        }
        return response.page(requestedPage: page, requestedSize: size, items: items)
    }

    func getMyHangouts(
        userId: String?,
        page: Int,
        size: Int
    ) async throws(APIError) -> Page<HangoutsModuleModel.CardInputData> {
        let myUserId = await tokenManager.getUserId()
        let userId = userId ?? myUserId
        let response = try await dataSource.fetchMyHangouts(id: userId, page: page, size: size)
        let items: [HangoutsModuleModel.CardInputData] = response.content.map { item in
            let tags: [AppUIEntities.Tags] = item.categories.map { category in
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
                requestType: item.status ?? .none,
                location: item.location,
                hangoutDate: Date.fromISO8601(item.hangoutDate),
                role: item.role
            )
        }
        return response.page(requestedPage: page, requestedSize: size, items: items)
    }

    func getMyEvents(
        page: Int,
        size: Int
    ) async throws(APIError) -> Page<EventsModuleModel.CardInputData> {
        let response = try await dataSource.fetchMyEvents(page: page, size: size)
        let items: [EventsModuleModel.CardInputData] = response.content.map { item in
            let tags: [AppPresentationModel.Tags] = item.categoryResponses.map { category in
                .init(
                    id: category.id ?? 0,
                    type: "",
                    title: category.title ?? "-"
                )
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
        return response.page(requestedPage: page, requestedSize: size, items: items)
    }
}
