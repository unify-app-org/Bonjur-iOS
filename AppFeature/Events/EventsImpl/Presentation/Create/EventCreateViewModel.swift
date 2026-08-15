//
//  EventCreateViewModel.swift
//  EventsImpl
//
//  Created by Huseyn Hasanov on 21.02.26.
//

import AppFoundation
import AppNetwork
import AppUIKit
import Foundation

final class EventCreateViewModel: UIFeatureViewModel<EventCreateFeature> {

    struct Dependencies {
        let useCase: EventsUseCase
    }

    private let router: EventCreateRouterProtocol
    private let inputData: EventCreateInputData
    private let dependencies: EventCreateViewModel.Dependencies

    init(
        state: EventCreateFeature.State,
        router: EventCreateRouterProtocol,
        inputData: EventCreateInputData,
        dependencies: EventCreateViewModel.Dependencies
    ) {
        self.router = router
        self.inputData = inputData
        self.dependencies = dependencies
        super.init(initialState: state)

        if inputData.eventId != nil {
            self.state.isEdit = true
        }
    }

    override func handle(action: EventCreateFeature.Action) {
        switch action {
        case .fetchData:
            fetchData()
        case .retryTapped:
            fetchData()
        case .createClubTapped:
            Task { await router.navigate(to: .createClub) }
        case .browseClubsTapped:
            Task { await router.navigate(to: .browseClubs) }
        case .backTapped:
            Task { await router.navigate(to: .backTapped) }
        case .continueTapped:
            continueTapped()
        case .selectClubTapped:
            state.showClubPicker = true
        case .dismissClubPicker:
            state.showClubPicker = false
        case .selectClub(let club):
            state.selectedClub = club
            state.showClubPicker = false
        case .addCategoryTapped:
            state.showCategoryPicker = true
        case .removeCategory(let id):
            setCategory(id: id, selected: false)
            syncSelectedCategories()
        case .dismissCategoryPicker:
            syncSelectedCategories()
            state.showCategoryPicker = false
        case .categoryPickerDone:
            syncSelectedCategories()
            state.showCategoryPicker = false
        }
    }

    private func fetchData() {
        state.clubsPhase = .loading
        Task {
            await fetchClubs()
            await fetchCategories()
            applyPrefillData()
        }
    }

    private func applyPrefillData() {
        guard let prefill = inputData.prefillData else {
            return
        }
        state.selectedClub = state.clubs.first { item in
            prefill.selectedClubId == item.clubId
        }
        state.values.merge(prefill.values) { _, new in new }
        selectPrefilledCategories(state.values.tags(.category))
    }

    private func selectPrefilledCategories(_ categories: [EventsCreate.TagItem]) {
        let selectedIds = Set(categories.map(\.id))
        state.categorySections = state.categorySections.map { section in
            var section = section
            section.categories = section.categories.map { category in
                var category = category
                category.selected = selectedIds.contains(category.id)
                return category
            }
            return section
        }
    }

    private func fetchClubs() async {
        do {
            let clubs = try await dependencies.useCase.fetchClubsForEvents()
            state.clubs = clubs
            if state.selectedClub == nil {
                state.selectedClub = clubs.first
            }
            // Editing an existing event: the club is fixed (selector disabled),
            // so never gate the form behind the empty state.
            if inputData.eventId != nil {
                state.clubsPhase = .loaded
            } else {
                state.clubsPhase = clubs.isEmpty ? .empty : .loaded
            }
        } catch {
            state.clubs = []
            state.clubsPhase = .failed
            AppSnackBar.show(title: "events_clubs_load_fail".localized, style: .error)
        }
    }

    private func fetchCategories() async {
        do {
            state.categorySections = try await dependencies.useCase.getCategories()
        } catch {
            state.categorySections = []
            AppSnackBar.show(title: "events_categories_load_fail".localized, style: .error)
        }
    }

    // MARK: - Categories

    private func setCategory(id: Int, selected: Bool) {
        state.categorySections = state.categorySections.map { section in
            var updated = section
            updated.categories = section.categories.map { category in
                var category = category
                if category.id == id { category.selected = selected }
                return category
            }
            return updated
        }
    }

    private func syncSelectedCategories() {
        state.values[.category] = .tags(
            state.selectedCategories.map { EventsCreate.TagItem(id: $0.id, label: $0.title) }
        )
    }

    // MARK: - Submit

    private func continueTapped() {
        guard let clubId = state.selectedClub?.clubId else { return }
        Task {
            postEffect(.loading(true))
            defer { postEffect(.loading(false)) }
            
            let multipart = await buildMultipart(clubId: clubId)
            let name = state.values.text(.eventName)
            do {
                if let eventId = inputData.eventId {
                    try await dependencies.useCase.editEvent(
                        eventId: eventId,
                        request: multipart
                    )
                    AppSnackBar.show(
                        title: "events_updated".localized,
                        subtitle: name,
                        style: .success
                    )
                } else {
                    try await dependencies.useCase.createEvent(request: multipart)
                    AppSnackBar.show(
                        title: "events_created".localized,
                        subtitle: "\(name) · now active",
                        style: .success
                    )
                }
                await router.navigate(to: .backTapped)
            } catch {
                postEffect(.error(error as? APIError))
            }
        }
    }

    private func buildMultipart(clubId: Int) async -> MultipartFormData {
        let values = state.values
        let links: [EventCreateRequest.Link] = values.links(.links).map {
            .init(type: $0.type, name: $0.name, url: $0.url)
        }
        let rule = values.text(.rules)
        let request = EventCreateRequest(
            clubId: clubId,
            name: values.text(.eventName),
            about: values.text(.about),
            location: values.text(.location),
            ownerContact: values.text(.ownerContact),
            capacity: Int(values.text(.capacity)),
            rule: rule.isEmpty ? nil : rule,
            visibility: values.radio(.visibility) == .public ? "PUBLIC" : "PRIVATE",
            eventDate: Self.isoFormatter.string(from: values.date(.eventDate)),
            reminderTimes: values.reminders(.reminder).map(\.rawValue),
            categoryIds: values.tags(.category).map(\.id),
            links: links,
            userIds: []
        )
        var multipart = MultipartFormData()
        multipart.addJSONField(name: "request", encodable: request)
        let coverURL = state.selectedClub?.backgroundURL
        if let coverURL, let data = await downloadData(from: coverURL) {
            multipart.addFile(
                name: "background",
                fileName: "background.jpg",
                mimeType: "image/jpeg",
                data: data
            )
        }
        for item in values.attachments(.attachment) {
            guard let data = await downloadData(from: item.url) else { continue }
            multipart.addFile(
                name: "attachments",
                fileName: item.name,
                mimeType: mimeType(for: item.url),
                data: data
            )
        }
        return multipart
    }

    // MARK: - File helpers

    private static let isoFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()

    private func downloadData(from url: URL) async -> Data? {
        if url.isFileURL {
            return readFileData(at: url)
        }
        return try? await URLSession.shared.data(from: url).0
    }

    private func readFileData(at url: URL) -> Data? {
        let scoped = url.startAccessingSecurityScopedResource()
        defer { if scoped { url.stopAccessingSecurityScopedResource() } }
        return try? Data(contentsOf: url)
    }

    private func mimeType(for url: URL) -> String {
        switch url.pathExtension.lowercased() {
        case "png": return "image/png"
        case "jpg", "jpeg": return "image/jpeg"
        case "pdf": return "application/pdf"
        case "doc", "docx": return "application/msword"
        default: return "application/octet-stream"
        }
    }
}
