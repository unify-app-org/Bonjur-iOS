//
//  ProfileSettingsRouter.swift
//  AppFeature
//
//  Created by Nahid Askerli on 26.02.26.
//

import UIKit

enum ProfileSettingsRoute {
}

protocol ProfileSettingsRouterProtocol {
    @MainActor
    func navigate(to route: ProfileSettingsRoute)
}

final class ProfileSettingsRouter: ProfileSettingsRouterProtocol {
    weak var view: UIViewController?
    
    @MainActor
    func navigate(to route: ProfileSettingsRoute) {
    }
}
