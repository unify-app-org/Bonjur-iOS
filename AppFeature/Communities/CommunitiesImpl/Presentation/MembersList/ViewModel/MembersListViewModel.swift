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

    private var users: [CommunitiesMemberModuleModel.MemberCellModel] = []
    private var page: Int = 0
    /// Bumped every time the list restarts from page 0 (search, reload, first load).
    /// A response tagged with an older generation belongs to the previous keyword and
    /// is dropped instead of landing on top of the current results.
    private var loadGeneration: Int = 0
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
            let generation = await MainActor.run { startNewSequence() }
            await load(page: 0, replacing: true, generation: generation)
        }
    }
    
    private func startNewSequence() -> Int {
        loadGeneration += 1
        return loadGeneration
    }

    private var keyword: String? {
        let trimmed = state.searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : trimmed
    }

    private func reload() {
        guard !state.isLoading else { return }
        state.isLoading = true
        let generation = startNewSequence()
        Task {
            await load(page: 0, replacing: true, generation: generation)
            await MainActor.run { state.isLoading = false }
        }
    }

    private func onAppear() {
        state.title = inputData.title
        state.optionsConfig = inputData.options
        state.totalCount = inputData.totalCount
        guard users.isEmpty, !state.isLoading else { return }
        state.isLoading = true
        postEffect(.loading(true))
        let generation = startNewSequence()
        Task {
            await load(page: 0, replacing: true, generation: generation)
            await MainActor.run {
                state.isLoading = false
                postEffect(.loading(false))
            }
        }
    }

    private func loadMore() {
        guard !state.isLoadingMore, !state.isLoading, state.hasMore else { return }
        state.isLoadingMore = true
        let generation = loadGeneration
        Task {
            await load(page: page + 1, replacing: false, generation: generation)
        }
    }

    private func load(page: Int, replacing: Bool, generation: Int) async {
        do {
            let result = try await inputData.loadPage(page, inputData.pageSize, keyword)
            await MainActor.run {
                guard generation == loadGeneration else {
                    // Stale result: drop the rows, but still release the paging flag —
                    // leaving it set would block every later page.
                    finishLoadingFlags()
                    return
                }
                if replacing {
                    users = result.members
                    state.pagesLoaded = 0
                    state.listResetToken += 1
                } else {
                    users.append(contentsOf: result.members)
                }
                var seen = Set<String>()
                users = users.filter { seen.insert($0.id).inserted }
                self.page = page
                state.hasMore = result.hasMore
                if let total = result.totalCount { state.totalCount = total }
                state.pagesLoaded += 1
                rebuildSections()
                finishLoadingFlags()
            }
        } catch {
            await MainActor.run {
                guard generation == loadGeneration else {
                    finishLoadingFlags()
                    return
                }
                state.hasMore = false
                rebuildSections()
                finishLoadingFlags()
            }
        }
    }

    @MainActor
    private func finishLoadingFlags() {
        state.isLoadingMore = false
    }

    @MainActor
    private func rebuildSections() {
        let grouped = CommunitiesMemberModuleModel.GroupedMembersData(
            users: users,
            roleTitles: inputData.roleTitles
        )
        let currentUserId = inputData.options?.currentUserId
        let sections = sectionsWithServerTotal(grouped.sections)
        state.sections = sections.enumerated().map { index, section in
            currentUserId != nil
                ? .browseOptions(id: "section-\(index)", section: section, currentUserId: currentUserId)
                : .browse(id: "section-\(index)", section: section)
        }
        state.isEmpty = users.isEmpty
        state.loadedCount = users.count
    }
    
    @MainActor
    private func sectionsWithServerTotal(
        _ sections: [CommunitiesMemberModuleModel.MemberListSection]
    ) -> [CommunitiesMemberModuleModel.MemberListSection] {
        guard
            let total = state.totalCount,
            let widestIndex = sections
                .enumerated()
                .max(by: { $0.element.members.count < $1.element.members.count })?
                .offset
        else { return sections }

        let othersCount = sections.enumerated()
            .filter { $0.offset != widestIndex }
            .reduce(0) { $0 + $1.element.members.count }
        let widest = sections[widestIndex]
        let headerCount = max(total - othersCount, widest.members.count)

        var result = sections
        result[widestIndex] = .init(
            title: widest.title,
            memberCount: headerCount,
            members: widest.members
        )
        return result
    }
}
