//
//  ProfileDetailViewModel.swift
//  ProfileImpl
//
//  Created by Huseyn Hasanov on 04.02.26.
//

import AppFoundation
import AppUIKit
import AppNetwork
import Clubs
import Events
import Hangouts

final class ProfileDetailViewModel: UIFeatureViewModel<ProfileDetailFeature> {
    
    struct Dependencies {
        let useCase: ProfileUseCase
        let tokenManager: TokenManager
    }
    
    private let router: ProfileDetailRouterProtocol
    private let inputData: ProfileDetailInputData
    private let dependencies: ProfileDetailViewModel.Dependencies

    private struct InitialFetchResults {
        let user: APIResult<ProfileDetail.UIModel>
        let clubs: APIResult<Page<ClubsModuleModel.CardInputData>>
        let events: APIResult<Page<EventsModuleModel.CardInputData>>
        let hangouts: APIResult<Page<HangoutsModuleModel.CardInputData>>
    }

    private static let pageSize = 10

    /// Last page index fetched per tab, and the in-flight guard that keeps the
    /// end-of-list sentinel from firing the same page twice while it scrolls past.
    private var clubsPage = 0
    private var eventsPage = 0
    private var hangoutsPage = 0
    private var isLoadingMoreClubs = false
    private var isLoadingMoreEvents = false
    private var isLoadingMoreHangouts = false

    init(
        state: ProfileDetailFeature.State,
        router: ProfileDetailRouterProtocol,
        inputData: ProfileDetailInputData,
        dependencies: ProfileDetailViewModel.Dependencies
    ) {
        self.router = router
        self.inputData = inputData
        self.dependencies = dependencies
        super.init(initialState: state)
    }
    
    override func handle(action: ProfileDetailFeature.Action) {
        switch action {
        case .fetchData:
            fetchData()
        case .loadMoreClubs:
            loadMoreClubs()
        case .loadMoreEvents:
            loadMoreEvents()
        case .loadMoreHangouts:
            loadMoreHangouts()
        case .editProfile:
            Task {
                guard let uiModel = state.uiModel else { return }
                await router.navigate(
                    to: .editProfile(
                        .init(profileData: uiModel)
                    )
                )
            }
        case .clubsItemTapped(let id):
            Task {
                await router.navigate(to: .clubsDetails(id: id))
            }
        case .eventsItemTapped(let id):
            Task {
                await router.navigate(to: .eventsDetails(id: id))
            }
        case .hangoutsItemTapped(let id):
            Task {
                await router.navigate(to: .hangoutsDetails(id: id))
            }
        case .settingsTapped:
            Task {
                await router.navigate(to: .settings)
            }
        case .activitiesTapped:
            Task {
                await router.navigate(to: .activities)
            }
        case .userCardTapped:
            guard let userCardModel = self.state.uiModel?.userCardModel else {
                return
            }
            Task {
                await router.navigate(
                    to: .studentCard(
                        .init(
                            userCardModel: userCardModel,
                            onSave: { [weak self] backgroundType in
                                self?.applyUserCardCover(backgroundType)
                            }
                        )
                    )
                )
            }
        case .userCardCoverSaved(let backgroundType):
            applyUserCardCover(backgroundType)
        }
    }
    
    private func fetchData() {
        clubsPage = 0
        eventsPage = 0
        hangoutsPage = 0
        Task {
            postEffect(.loading(true))
            defer {
                postEffect(.loading(false))
            }

            let results = await fetchInitialData()
            let firstError = applyInitialFetchResults(results)

            if let firstError {
                postEffect(.error(APIError.popupTitle, firstError.popupSubtitle))
            }
        }
    }
    
    private func fetchInitialData() async -> InitialFetchResults {
        async let user = apiResult {
            try await dependencies.useCase.getProfileData(
                userId: inputData.userId,
                communityId: inputData.communityId
            )
        }
        async let clubs = apiResult {
            try await dependencies.useCase.getMyClubs(
                userId: inputData.userId,
                page: 0,
                size: Self.pageSize
            )
        }
        async let events = apiResult {
            try await dependencies.useCase.getMyEvents(
                page: 0,
                size: Self.pageSize
            )
        }
        async let hangouts = apiResult {
            try await dependencies.useCase.getMyHangouts(
                userId: inputData.userId,
                page: 0,
                size: Self.pageSize
            )
        }

        return await .init(
            user: user,
            clubs: clubs,
            events: events,
            hangouts: hangouts
        )
    }
    
    private func applyInitialFetchResults(
        _ results: InitialFetchResults
    ) -> APIError? {
        var firstError: APIError?

        switch results.user {
        case .success(let user):
            state.uiModel = user
            Task {
                let myId = await dependencies.tokenManager.getUserId()
                if let id = inputData.userId, id != myId {
                    state.navigationTitle = "profile_about_user".localized
                    state.isOtherUser = true
                } else {
                    // Own profile: refresh what the home-screen widget shows.
                    UserCardWidgetPublisher.publish(
                        card: user.userCardModel,
                        userId: myId
                    )
                }
            }
        case .failure(let error):
            firstError = firstError ?? error
        }

        switch results.clubs {
        case .success(let clubs):
            state.clubs = clubs.items
            state.clubsHasMore = clubs.hasMore
            state.clubsPagesLoaded = 1
        case .failure(let error):
            firstError = firstError ?? error
        }

        switch results.events {
        case .success(let events):
            // `events/my` returns the logged-in user's events only,
            // so hide them when viewing another user's profile.
            let isOwnProfile = inputData.userId == nil
            state.events = isOwnProfile ? events.items : []
            state.eventsHasMore = isOwnProfile && events.hasMore
            state.eventsPagesLoaded = 1
        case .failure(let error):
            firstError = firstError ?? error
        }

        switch results.hangouts {
        case .success(let hangouts):
            state.hangouts = hangouts.items
            state.hangoutsHasMore = hangouts.hasMore
            state.hangoutsPagesLoaded = 1
        case .failure(let error):
            firstError = firstError ?? error
        }
        
        return firstError
    }
    
    // MARK: - Paging

    private func loadMoreClubs() {
        guard !isLoadingMoreClubs, state.clubsHasMore else { return }
        isLoadingMoreClubs = true
        let nextPage = clubsPage + 1

        Task {
            defer { isLoadingMoreClubs = false }
            do {
                let result = try await dependencies.useCase.getMyClubs(
                    userId: inputData.userId,
                    page: nextPage,
                    size: Self.pageSize
                )
                clubsPage = result.page
                state.clubs = Self.appending(result.items, to: state.clubs, id: \.id)
                state.clubsHasMore = result.hasMore
                state.clubsPagesLoaded += 1
            } catch {
                // Stop paging rather than retry-looping the sentinel on every scroll.
                state.clubsHasMore = false
                postEffect(.error(APIError.popupTitle, (error as? APIError).popupSubtitle))
            }
        }
    }

    private func loadMoreEvents() {
        guard !isLoadingMoreEvents, state.eventsHasMore else { return }
        isLoadingMoreEvents = true
        let nextPage = eventsPage + 1

        Task {
            defer { isLoadingMoreEvents = false }
            do {
                let result = try await dependencies.useCase.getMyEvents(
                    page: nextPage,
                    size: Self.pageSize
                )
                eventsPage = result.page
                state.events = Self.appending(result.items, to: state.events, id: \.id)
                state.eventsHasMore = result.hasMore
                state.eventsPagesLoaded += 1
            } catch {
                state.eventsHasMore = false
                postEffect(.error(APIError.popupTitle, (error as? APIError).popupSubtitle))
            }
        }
    }

    private func loadMoreHangouts() {
        guard !isLoadingMoreHangouts, state.hangoutsHasMore else { return }
        isLoadingMoreHangouts = true
        let nextPage = hangoutsPage + 1

        Task {
            defer { isLoadingMoreHangouts = false }
            do {
                let result = try await dependencies.useCase.getMyHangouts(
                    userId: inputData.userId,
                    page: nextPage,
                    size: Self.pageSize
                )
                hangoutsPage = result.page
                state.hangouts = Self.appending(result.items, to: state.hangouts, id: \.id)
                state.hangoutsHasMore = result.hasMore
                state.hangoutsPagesLoaded += 1
            } catch {
                state.hangoutsHasMore = false
                postEffect(.error(APIError.popupTitle, (error as? APIError).popupSubtitle))
            }
        }
    }

    /// Appends a page, dropping rows already on screen. The server re-sorts by
    /// `modifiedAt`, so a row can shift across the page boundary and arrive twice.
    private static func appending<Item, ID: Hashable>(
        _ newItems: [Item],
        to existing: [Item],
        id: (Item) -> ID
    ) -> [Item] {
        var seen = Set(existing.map(id))
        return existing + newItems.filter { seen.insert(id($0)).inserted }
    }

    private func editUser(
        _ request: ProfileDTOModel.UpdateRequest?
    ) async {
        postEffect(.loading(true))
        defer {
            postEffect(.loading(false))
        }
        do {
            _ = try await dependencies.useCase.editProfile(
                multiPart: nil,
                queryData: request
            )
            AppSnackBar.show(
                title: "Cover updated successfully",
                subtitle: "Your changes are saved",
                style: .success
            )
        } catch {
            postEffect(.error(APIError.popupTitle, (error as? APIError).popupSubtitle))
        }
    }
    
    private func buildRequest(
        bgType: AppUIEntities.BackgroundType?
    ) -> (
        ProfileDTOModel.UpdateRequest?
    ) {
        let gender = state.uiModel?.gender?.type.rawValue ?? "-"
        let categories = state.uiModel?.tags.map({ $0.id }) ?? []
        let languages = state.uiModel?.languages?.map({ $0.id }) ?? []
        let birthDate = state.uiModel?.birthday ?? ""
        
        let request: ProfileDTOModel.UpdateRequest = .init(
            birthDate: birthDate,
            gender: gender,
            about: state.uiModel?.about ?? "",
            categoriesId: categories,
            languagesId: languages,
            background: bgType
        )
        return request
    }
    
    private func applyUserCardCover(_ backgroundType: AppUIEntities.BackgroundType?) {
        guard let currentUIModel = state.uiModel else {
            return
        }
        
        let updatedUserCardModel = UserCardModel(
            backgroundCover: backgroundType,
            nameSurname: currentUIModel.userCardModel.nameSurname,
            speciality: currentUIModel.userCardModel.speciality,
            course: currentUIModel.userCardModel.course,
            community: currentUIModel.userCardModel.community,
            degree: currentUIModel.userCardModel.degree,
            entryYear: currentUIModel.userCardModel.entryYear,
            email: currentUIModel.userCardModel.email,
            imageUrl: currentUIModel.userCardModel.imageUrl
        )
        
        let updatedUIModel = ProfileDetail.UIModel(
            userCardModel: updatedUserCardModel,
            about: currentUIModel.about,
            gender: currentUIModel.gender,
            birthday: currentUIModel.birthday,
            languages: currentUIModel.languages,
            tags: currentUIModel.tags
        )
        
        state.uiModel = updatedUIModel
        
        let request = buildRequest(bgType: backgroundType)
        Task {
            await editUser(request)
        }
    }
}
