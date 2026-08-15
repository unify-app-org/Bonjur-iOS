//
//  ClubCreateViewModel.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 21.02.26.
//

import AppFoundation
import AppNetwork
import AppStorage
import AppUIKit
import AppPresentationModel

final class ClubCreateViewModel: UIFeatureViewModel<ClubCreateFeature> {
    
    struct Dependencies {
        let useCase: ClubsUseCase
        let userDefaults: UserDefaultsProtocol
    }
    
    private let router: ClubCreateRouterProtocol
    private let inputData: ClubCreateInputData
    private let dependencies: ClubCreateViewModel.Dependencies
    private var didApplyPrefillData = false
    
    init(
        state: ClubCreateFeature.State,
        router: ClubCreateRouterProtocol,
        inputData: ClubCreateInputData,
        dependencies: ClubCreateViewModel.Dependencies
    ) {
        self.router = router
        self.inputData = inputData
        self.dependencies = dependencies
        super.init(initialState: state)
        
        if inputData.id != nil {
            self.state.disabledFieldIDs = [.clubName]
        }
    }
    
    override func handle(action: ClubCreateFeature.Action) {
        switch action {
        case .backTapped:
            Task {
                await router.navigate(to: .backTapped)
            }
        case .fetchData:
            fetchData()
        case .addCategoryTapped:
            state.showCategoryPicker = true
        case .removeCategory(let id):
            toggleCategory(with: id, selected: false)
            syncSelectedCategories()
        case .dismissCategoryPicker:
            syncSelectedCategories()
            state.showCategoryPicker = false
        case .categoryPickerDone:
            syncSelectedCategories()
            state.showCategoryPicker = false
        case .continueTapped:
            continueTapped()
        case .requestVerificationTapped:
            requestVerification()
        case .dismissVerifyPrompt:
            dismissVerifyPrompt()
        }
    }

    // MARK: - Verification prompt

    /// Fire the real verify request for the just-created club, then leave the
    /// create flow. Falls back to a soft message if we somehow lack the new id.
    private func requestVerification() {
        state.showVerifyPrompt = false
        guard let clubId = state.createdClubId else {
            AppSnackBar.show(
                title: "clubs_verification_requested".localized,
                subtitle: "clubs_verification_requested_sub".localized,
                style: .success
            )
            Task { await router.navigate(to: .backTapped) }
            return
        }
        Task {
            do {
                try await dependencies.useCase.requestVerify(id: clubId)
                AppSnackBar.show(
                    title: "clubs_verification_requested".localized,
                    subtitle: "clubs_verification_requested_sub".localized,
                    style: .success
                )
            } catch {
                AppSnackBar.show(
                    title: "clubs_verification_fail".localized,
                    subtitle: "clubs_verification_fail_sub_create".localized,
                    style: .error
                )
            }
            await router.navigate(to: .backTapped)
        }
    }

    private func dismissVerifyPrompt() {
        state.showVerifyPrompt = false
        Task { await router.navigate(to: .backTapped) }
    }
    
    private func fetchData() {
        Task {
            await fetchCreate()
            await fetchCategories()
            await applyPrefillData()
        }
    }
    
    private func fetchCreate() async {
        do {
            let data = try await dependencies.useCase.fetchCreateFields()
            state.clubsCreateSchema = data
        } catch {
            AppSnackBar.show(title: "clubs_form_load_fail".localized, style: .error)
        }
    }

    private func fetchCategories() async {
        do {
            state.categorySections = try await dependencies.useCase.getCategories()
        } catch {
            state.categorySections = []
            AppSnackBar.show(title: "clubs_categories_load_fail".localized, style: .error)
        }
    }
    
    @MainActor
    private func applyPrefillData() {
        guard !didApplyPrefillData,
              let prefillData = inputData.prefillData else {
            return
        }
        
        didApplyPrefillData = true
        state.existingLogoURL = prefillData.logoURL
        state.existingCoverURL = prefillData.coverURL
        state.values.merge(prefillData.values) { _, new in new }
        selectPrefilledCategories(prefillData.values.tags(.category))
    }
    
    private func selectPrefilledCategories(_ categories: [ClubsCreate.TagItem]) {
        let selectedIds = Set(categories.map(\.id))
        state.categorySections = state.categorySections.map { section in
            var updatedSection = section
            updatedSection.categories = section.categories.map { category in
                var updatedCategory = category
                updatedCategory.selected = selectedIds.contains(category.id)
                return updatedCategory
            }
            return updatedSection
        }
    }
    
    private func toggleCategory(with id: Int, selected: Bool) {
        state.categorySections = state.categorySections.map { section in
            var updatedSection = section
            updatedSection.categories = section.categories.map { category in
                var updatedCategory = category
                if category.id == id {
                    updatedCategory.selected = selected
                }
                return updatedCategory
            }
            return updatedSection
        }
    }
    
    private func syncSelectedCategories() {
        state.values[.category] = .tags(
            state.selectedCategories.map {
                ClubsCreate.TagItem(id: $0.id, label: $0.title)
            }
        )
    }
    
    private func continueTapped() {
        Task {
            if let id = inputData.id {
                await editClub(id: id)
            } else {
                await createClub()
            }
        }
    }
    
    private func editClub(id: Int) async {
        postEffect(.loading(true))
        defer {
            postEffect(.loading(false))
        }
        do {
            try await dependencies.useCase.editClub(
                id: id,
                request: buildRequest()
            )
            AppSnackBar.show(
                title: "clubs_updated".localized,
                subtitle: state.values.text(.clubName),
                style: .success
            )
        } catch {
            postEffect(.error(error as? APIError))
        }
    }

    private func createClub() async {
        postEffect(.loading(true))
        defer {
            postEffect(.loading(false))
        }
        do {
            let createdId = try await dependencies.useCase.createClub(request: buildRequest())
            state.createdClubId = createdId
            state.showVerifyPrompt = true
        } catch {
            postEffect(.error(error as? APIError))
        }
    }
    
    private func buildRequest() -> MultipartFormData {
        var multiPartData = MultipartFormData()
        let name = state.values.text(.clubName)
        let ownerContact = state.values.text(.ownerContact)
        let about = state.values.text(.about)
        let visibility = state.values.radio(.visibility)
        let location = state.values.text(.location)
        let links: [ClubDTOModel.Link] = state.values.links(.links).map { item in
                .init(type: item.type, name: item.name, url: item.url)
        }
        let bgColor = state.values.cover(.cover)
        let capacity = Int(state.values.text(.capacity))
        let categoryIds = state.values.tags(.category).map { $0.id }
        let rules = state.values.text(.rules)
        let communityId = dependencies.userDefaults.integer(forKey: .communityId)
        
        let request = ClubDTOModel.Request(
            communityId: communityId,
            name: name,
            ownerContact: ownerContact,
            about: about,
            visibility: visibility,
            location: location,
            links: links,
            backgroundColour: bgColor,
            capacity: capacity,
            categoryIds: categoryIds,
            rule: rules
        )
        multiPartData.addJSONField(name: "request", encodable: request)
        if let logo = state.selectedLogo {
            multiPartData.addFile(
                name: "clubProfile",
                fileName: "clubProfile.jpg",
                mimeType: "image/jpeg",
                data: logo
            )
        }
        if let bgPhoto = state.backgroundPhoto {
            multiPartData.addFile(
                name: "backgroundPhoto",
                fileName: "backgroundPhoto.jpg",
                mimeType: "image/jpeg",
                data: bgPhoto
            )
        }
        return multiPartData
    }
}
