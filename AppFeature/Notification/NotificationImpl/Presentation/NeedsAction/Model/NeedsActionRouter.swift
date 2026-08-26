//
//  NeedsActionRouter.swift
//  NotificationImpl
//
//  Created by Huseyn Hasanov on 28.06.26.
//

import UIKit
import Profile

enum NeedsActionRoute {
    /// Admin-only club verification queue.
    case verification
    /// The requester's profile (tapping a request cell).
    case userProfile(userId: String)
}

protocol NeedsActionRouterProtocol {
    @MainActor
    func navigate(to route: NeedsActionRoute)
}

final class NeedsActionRouter: NeedsActionRouterProtocol {
    weak var view: UIViewController?

    private let profileModule: ProfileModule

    init(
        view: UIViewController? = nil,
        profileModule: ProfileModule = resolve()
    ) {
        self.view = view
        self.profileModule = profileModule
    }

    @MainActor
    func navigate(to route: NeedsActionRoute) {
        switch route {
        case .verification:
            let vc = VerificationBuilder(inputData: .init()).build()
            view?.navigationController?.pushViewController(vc, animated: true)
        case .userProfile(let userId):
            guard let vc = profileModule.makeProfileViewController(userId: userId, communityId: nil) as? UIViewController else { return }
            view?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
