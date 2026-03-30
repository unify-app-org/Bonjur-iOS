//
//  ProfileSettingsRouter.swift
//  ProfileImpl
//
//  Created by Nahid Askerli on 26.03.26.
//

import UIKit

enum ProfileSettingsRoute {
    case back
    case language
    case helpCenter
    case termsAndConditions
    case deleteAccount
    case logout
}

protocol ProfileSettingsRouterProtocol {
    @MainActor
    func navigate(to route: ProfileSettingsRoute)
}

final class ProfileSettingsRouter: ProfileSettingsRouterProtocol {
    weak var view: UIViewController?
    
    @MainActor
    func navigate(to route: ProfileSettingsRoute) {
        switch route {
        case .back:
            break
        case .language:
            break
        case .helpCenter:
            break
        case .termsAndConditions:
            break
        case .deleteAccount:
            break
        case .logout:
            break
        }
    }
}
