//
//  VerificationRouter.swift
//  NotificationImpl
//
//  Created by Huseyn Hasanov on 28.06.26.
//

import UIKit
import Clubs

enum VerificationRoute {
    /// The club's detail screen (tapping a verification cell).
    case clubDetail(clubId: Int)
}

protocol VerificationRouterProtocol {
    @MainActor
    func navigate(to route: VerificationRoute)
}

final class VerificationRouter: VerificationRouterProtocol {
    weak var view: UIViewController?

    private let clubModule: ClubsModule

    init(
        view: UIViewController? = nil,
        clubModule: ClubsModule = resolve()
    ) {
        self.view = view
        self.clubModule = clubModule
    }

    @MainActor
    func navigate(to route: VerificationRoute) {
        switch route {
        case .clubDetail(let clubId):
            guard let vc = clubModule.makeClubsDetailsVC(clubId: clubId) as? UIViewController else { return }
            view?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
