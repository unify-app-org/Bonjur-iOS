//
//  MembersListViewModel.swift
//  CommunitiesImpl
//
//  Created by Claude on 15.06.26.
//

import AppFoundation
import Communities

final class MembersListViewModel: UIFeatureViewModel<MembersListFeature> {

    struct Dependencies {
    }

    private let router: MembersListRouterProtocol
    private let inputData: MembersListInputData
    private let dependencies: MembersListViewModel.Dependencies

    /// Accumulated members across the pages loaded so far.
    private var users: [CommunitiesMemberModuleModel.MemberCellModel] = []
    /// Index of the most recently loaded page.
    private var page: Int = 0
    /// Debounce for server-side search, mirroring the clubs/events list (300ms).
    private let searchDebounceNanoseconds: UInt64 = 300_000_000
    private var searchTask: Task<Void, Never>?

    init(
        state: MembersListFeature.State,
        router: MembersListRouterProtocol,
        inputData: MembersListInputData,
        dependencies: MembersListViewModel.Dependencies
    ) {
        self.router = router
        self.inputData = inputData
        self.dependencies = dependencies
        super.init(initialState: state)
    }

    override func handle(action: MembersListFeature.Action) {
        switch action {
        case .onAppear:
            onAppear()
        case .loadMore:
            loadMore()
        case .memberTapped(let row):
            inputData.onMemberTapped(row.member)
        case .reload:
            reload()
        case .searchChanged(let text):
            searchChanged(text)
        }
    }

    private func searchChanged(_ text: String) {
        state.searchText = text
        searchTask?.cancel()
        searchTask = Task { [weak self] in
            guard let self else { return }
            try? await Task.sleep(nanoseconds: searchDebounceNanoseconds)
            guard !Task.isCancelled else { return }
            await load(page: 0, replacing: true)
        }
    }

    /// Trimmed search term, nil when blank so the query param is omitted.
    private var keyword: String? {
        let trimmed = state.searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : trimmed
    }

    private func reload() {
        guard !state.isLoading else { return }
        state.isLoading = true
        Task {
            await load(page: 0, replacing: true)
            await MainActor.run { state.isLoading = false }
        }
    }

    private func onAppear() {
        state.title = inputData.title
        state.optionsConfig = inputData.options
        guard users.isEmpty, !state.isLoading else { return }
        state.isLoading = true
        postEffect(.loading(true))
        Task {
            await load(page: 0, replacing: true)
            await MainActor.run {
                state.isLoading = false
                postEffect(.loading(false))
            }
        }
    }

    private func loadMore() {
        guard !state.isLoadingMore, !state.isLoading, state.hasMore else { return }
        state.isLoadingMore = true
        Task {
            await load(page: page + 1, replacing: false)
            await MainActor.run {
                state.isLoadingMore = false
            }
        }
    }

    private func load(page: Int, replacing: Bool) async {
        do {
            let result = try await inputData.loadPage(page, inputData.pageSize, keyword)
            await MainActor.run {
                if replacing {
                    users = result.members
                } else {
                    users.append(contentsOf: result.members)
                }
                self.page = page
                state.hasMore = result.hasMore
                rebuildSections()
            }
        } catch {
            await MainActor.run {
                state.hasMore = false
                rebuildSections()
            }
        }
    }

    @MainActor
    private func rebuildSections() {
        let grouped = CommunitiesMemberModuleModel.GroupedMembersData(
            users: users,
            titleOverrides: inputData.titleOverrides
        )
        let currentUserId = inputData.options?.currentUserId
        state.sections = grouped.sections.enumerated().map { index, section in
            currentUserId != nil
                ? .browseOptions(id: "section-\(index)", section: section, currentUserId: currentUserId)
                : .browse(id: "section-\(index)", section: section)
        }
        state.isEmpty = users.isEmpty
    }
}
