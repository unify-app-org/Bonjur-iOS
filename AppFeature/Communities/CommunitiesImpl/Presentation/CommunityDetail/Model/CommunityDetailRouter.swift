//
//  CommunityDetailRouter.swift
//  CommunitiesImpl
//
//  Created by Huseyn Hasanov on 03.02.26.
//

import UIKit
import Clubs
import Profile
import Communities

enum CommunityDetailRoute {
    case back
    case clubsDetails(id: Int)
    case userDetails(id: String)
    case edit(id: Int, prefillData: ClubsModuleModel.CreatePrefillData)
    case membersList(CommunitiesMemberModuleModel.MembersListInput)
}

protocol CommunityDetailRouterProtocol {
    @MainActor
    func navigate(to route: CommunityDetailRoute)
}

final class CommunityDetailRouter: CommunityDetailRouterProtocol {
    weak var view: UIViewController?
    private var clubModule: ClubsModule
    private var profileModule: ProfileModule
    private var communitiesModule: CommunitiesModule
    
    init(
        view: UIViewController? = nil,
        clubModule: ClubsModule = resolve(),
        profileModule: ProfileModule = resolve(),
        communitiesModule: CommunitiesModule = resolve()
    ) {
        self.view = view
        self.clubModule = clubModule
        self.profileModule = profileModule
        self.communitiesModule = communitiesModule
    }
    
    @MainActor
    func navigate(to route: CommunityDetailRoute) {
        switch route {
        case .clubsDetails(let id):
            let vc = clubModule.makeClubsDetailsVC(clubId: id) as! UIViewController
            self.view?.navigationController?.pushViewController(vc, animated: true)
        case .edit(let id, let prefillData):
            let vc = clubModule.makeCreateVC(
                id: id,
                prefillData: prefillData
            ) as! UIViewController
            self.view?.navigationController?.pushViewController(vc, animated: true)
        case .back:
            self.view?.navigationController?.popViewController(animated: true)
        case .userDetails(let id):
            let vc = profileModule.makeProfileViewController(userId: id) as! UIViewController
            view?.navigationController?.pushViewController(vc, animated: true)
        case .membersList(let input):
            guard let vc = communitiesModule.makeMembersListScreen(input: input) as? UIViewController else { return }
            view?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
