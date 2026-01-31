//
//  GroupsListRouter.swift
//  GroupsImpl
//
//  Created by Huseyn Hasanov on 23.01.26.
//

import UIKit
import Clubs

enum GroupsListRoute {
    case clubDetail(id: Int)
}

protocol GroupsListRouterProtocol {
    @MainActor
    func navigate(to route: GroupsListRoute)
}

final class GroupsListRouter: GroupsListRouterProtocol {
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
    func navigate(to route: GroupsListRoute) {
        switch route {
        case .clubDetail(let id):
            let vc = clubModule.makeClubsDetailsVC(clubId: id) as! UIViewController
            vc.hidesBottomBarWhenPushed = true
            self.view?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
