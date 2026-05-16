//
//  ClubDetailsRouter.swift
//  AppAuth
//
//  Created by Huseyn Hasanov on 29.01.26.
//

import UIKit
import Profile

enum ClubDetailsRoute {
    case backTapped
    case userDetail(String)
}

protocol ClubDetailsRouterProtocol {
    @MainActor
    func navigate(to route: ClubDetailsRoute)
}

final class ClubDetailsRouter: ClubDetailsRouterProtocol {
    weak var view: UIViewController?
    private let profile: ProfileModule
    
    init(
        view: UIViewController? = nil,
        profile: ProfileModule = resolve()
    ) {
        self.view = view
        self.profile = profile
    }
    
    @MainActor
    func navigate(to route: ClubDetailsRoute) {
        switch route {
        case .backTapped:
            self.view?.navigationController?.popViewController(animated: true)
        case .userDetail(let id):
            let vc = profile.makeProfileViewController(userId: id) as! UIViewController
            view?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
