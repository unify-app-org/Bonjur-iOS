//
//  ClubDetailsRouter.swift
//  AppAuth
//
//  Created by Huseyn Hasanov on 29.01.26.
//

import UIKit
import Profile
import Communities

enum ClubDetailsRoute {
    case backTapped
    case editClub(id: Int, prefillData: ClubsCreate.PrefillData)
    case userDetail(String)
    case membersList(CommunitiesMemberModuleModel.MembersListInput)
}

protocol ClubDetailsRouterProtocol {
    @MainActor
    func navigate(to route: ClubDetailsRoute)
}

final class ClubDetailsRouter: ClubDetailsRouterProtocol {
    weak var view: UIViewController?
    private let profile: ProfileModule
    private let communitiesModule: CommunitiesModule

    init(
        view: UIViewController? = nil,
        profile: ProfileModule = resolve(),
        communitiesModule: CommunitiesModule = resolve()
    ) {
        self.view = view
        self.profile = profile
        self.communitiesModule = communitiesModule
    }
    
    @MainActor
    func navigate(to route: ClubDetailsRoute) {
        switch route {
        case .backTapped:
            self.view?.navigationController?.popViewController(animated: true)
        case .editClub(let id, let prefillData):
            let vc = ClubCreateBuilder(
                inputData: .init(
                    id: id,
                    prefillData: prefillData
                )
            ).build()
            view?.navigationController?.pushViewController(vc, animated: true)
        case .userDetail(let id):
            let vc = profile.makeProfileViewController(userId: id) as! UIViewController
            view?.navigationController?.pushViewController(vc, animated: true)
        case .membersList(let input):
            guard let vc = communitiesModule.makeMembersListScreen(input: input) as? UIViewController else { return }
            view?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
