//
//  AppDelegate+Localization.swift
//  App
//
//  Created by Huseyn Hasanov on 21.12.25.
//  Copyright © 2025 Unify. All rights reserved.
//

import AppLocalization
import DependecyInjection
import Foundation
import AppUIKit
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
        )
     }
}
