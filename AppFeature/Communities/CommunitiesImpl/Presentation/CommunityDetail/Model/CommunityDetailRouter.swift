//
//  CommunityDetailRouter.swift
//  CommunitiesImpl
//
//  Created by Huseyn Hasanov on 03.02.26.
//

import UIKit
import Clubs

enum CommunityDetailRoute {
    case clubsDetails(id: Int)
    case back
}

protocol CommunityDetailRouterProtocol {
    @MainActor
    func navigate(to route: CommunityDetailRoute)
}

final class CommunityDetailRouter: CommunityDetailRouterProtocol {
    weak var view: UIViewController?
    private var clubModule: ClubsModule
    init(
        view: UIViewController? = nil,
        clubModule: ClubsModule = resolve()
    ) {
        self.view = view
        self.clubModule = clubModule
    }
    @MainActor
    func navigate(to route: CommunityDetailRoute) {
        switch route {
        case .clubsDetails(let id):
            let vc = clubModule.makeClubsDetailsVC(clubId: id) as! UIViewController
            vc.hidesBottomBarWhenPushed = true
            self.view?.navigationController?.pushViewController(vc, animated: true)
        case .back:
            self.view?.navigationController?.popViewController(animated: true)
        }
    }
}
