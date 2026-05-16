//
//  CommunityDetailRouter.swift
//  CommunitiesImpl
//
//  Created by Huseyn Hasanov on 03.02.26.
//

import UIKit
import Clubs
import Profile

enum CommunityDetailRoute {
    case clubsDetails(id: Int)
    case userDetails(id: String)
    case back
}

protocol CommunityDetailRouterProtocol {
    @MainActor
    func navigate(to route: CommunityDetailRoute)
}

final class CommunityDetailRouter: CommunityDetailRouterProtocol {
    weak var view: UIViewController?
    private var clubModule: ClubsModule
    private var profileModule: ProfileModule
    
    init(
        view: UIViewController? = nil,
        clubModule: ClubsModule = resolve(),
        profileModule: ProfileModule = resolve()
    ) {
        self.view = view
        self.clubModule = clubModule
        self.profileModule = profileModule
    }
    
    @MainActor
    func navigate(to route: CommunityDetailRoute) {
        switch route {
        case .clubsDetails(let id):
            let vc = clubModule.makeClubsDetailsVC(clubId: id) as! UIViewController
            self.view?.navigationController?.pushViewController(vc, animated: true)
        case .back:
            self.view?.navigationController?.popViewController(animated: true)
        case .userDetails(let id):
            let vc = profileModule.makeProfileViewController(userId: id) as! UIViewController
            view?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
