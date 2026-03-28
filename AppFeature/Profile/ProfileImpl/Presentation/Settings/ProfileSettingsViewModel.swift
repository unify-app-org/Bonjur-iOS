//
//  ProfileSettingsViewModel.swift
//  ProfileImpl
//
//  Created by Nahid Askerli on 26.03.26.
//

import AppFoundation

final class ProfileSettingsViewModel: UIFeatureViewModel<ProfileSettingsFeature> {
    
    struct Dependencies {
    }
    
    private let router: ProfileSettingsRouterProtocol
    private let inputData: ProfileSettingsInputData
    private let dependencies: ProfileSettingsViewModel.Dependencies
    
    init(
        state: ProfileSettingsFeature.State,
        router: ProfileSettingsRouterProtocol,
        inputData: ProfileSettingsInputData,
        dependencies: ProfileSettingsViewModel.Dependencies
    ) {
        self.router = router
        self.inputData = inputData
        self.dependencies = dependencies
        super.init(initialState: state)
    }
    
    override func handle(action: ProfileSettingsFeature.Action) {
        switch action {
   
        case .didTapBack:
            Task { @MainActor in router.navigate(to: .back) }
        case .didTapLanguage:
            Task {@MainActor in router.navigate(to: .language) }
        case .didTapHelpCenter:
            Task {@MainActor in  router.navigate(to: .helpCenter)}
        case .didTapTerms:
            Task {@MainActor in  router.navigate(to: .termsAndConditions)}
        case .didTapDeleteAccount:
            Task {@MainActor in  router.navigate(to: .deleteAccount)}
        case .didTapLogOut:
            Task {@MainActor in router.navigate(to: .logout)}
        }
    }
    
    private func fetchData() {
        
    }
}
