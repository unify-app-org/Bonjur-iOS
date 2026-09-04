//
//  AppDelegate+Localization.swift
//  App
//
//  Created by Huseyn Hasanov on 21.12.25.
//  Copyright © 2025 Unify. All rights reserved.
//

import AppLocalization
import AppWidgetShared
import DependecyInjection
import Foundation
import WidgetKit
import AppUIKit
import AppPresentationModel
import AppAuthImpl
import ProfileImpl
import DiscoverImpl
import ClubsImpl
import HangoutsImpl
import EventsImpl
import CommunitiesImpl
import NotificationImpl
import GroupsImpl

extension AppDelegate {

    func setupLocalization(container: AppDIContainer) {
        let localization = container.resolve(AppLocalizationProtocol.self)
        // Each feature module ships its own {en,az,ru}.lproj; register every
        // module bundle so `.localized` can resolve that module's keys.
        localization.registerBundle(
            Bundle.main,
            Bundle(for: AuthModuleConfigurator.self),
            Bundle(for: ProfileConfigurator.self),
            Bundle(for: DiscoverConfigurator.self),
            Bundle(for: ClubsConfigurator.self),
            Bundle(for: HangoutsConfigurator.self),
            Bundle(for: EventsConfigurator.self),
            Bundle(for: CommunitiesConfigurator.self),
            Bundle(for: NotificationConfigurator.self),
            Bundle(for: GroupsConfigurator.self),
            Bundle(for: FilterViewModel.self),
            Bundle(for: AppPresentationModelBundleToken.self),
        )

        mirrorLanguageToWidget(localization.currentLanguage)
        observeLanguageChangesForWidget(localization)
     }

    /// The widget extension cannot read `UserDefaults.standard`, where
    /// `AppLocalizationImpl` keeps the choice — it has its own container. Mirror the
    /// code into the App Group so `WidgetStrings` can resolve the card's labels in
    /// the app's language instead of the device's.
    private func mirrorLanguageToWidget(_ code: String) {
        UserCardWidgetStore.saveLanguage(code)
    }

    /// A language switch does not touch the card data, so nothing else asks the
    /// widget to redraw — without this the placed card keeps the old language until
    /// the next profile load republishes the snapshot.
    private func observeLanguageChangesForWidget(_ localization: AppLocalizationProtocol) {
        NotificationCenter.default.addObserver(
            forName: .languageDidChange,
            object: nil,
            queue: .main
        ) { note in
            let code = (note.userInfo?["language"] as? String) ?? localization.currentLanguage
            UserCardWidgetStore.saveLanguage(code)
            WidgetCenter.shared.reloadTimelines(ofKind: UserCardWidgetStore.widgetKind)
        }
    }
}
