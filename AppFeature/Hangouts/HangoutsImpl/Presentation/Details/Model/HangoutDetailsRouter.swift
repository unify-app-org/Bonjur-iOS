//
//  HangoutDetailsRouter.swift
//  HangoutsImpl
//
//  Created by Huseyn Hasanov on 02.02.26.
//

import UIKit
import Communities
import Profile

enum HangoutDetailsRoute {
    case back
    case edit(id: String, prefillData: HangoutsCreate.PrefillData)
    case communityDetail(id: Int)
    case userDetail(String)
    case membersList(CommunitiesMemberModuleModel.MembersListInput)
}

protocol HangoutDetailsRouterProtocol {
    @MainActor
    func navigate(to route: HangoutDetailsRoute)
}

final class HangoutDetailsRouter: HangoutDetailsRouterProtocol {
    weak var view: UIViewController?
    private let communitiesModule: CommunitiesModule
    private let profile: ProfileModule

    init(
        communitiesModule: CommunitiesModule = resolve(),
        profile: ProfileModule = resolve()
    ) {
        self.communitiesModule = communitiesModule
        self.profile = profile
    }

    @MainActor
    func navigate(to route: HangoutDetailsRoute) {
        switch route {
        case .back:
            view?.navigationController?.popViewController(animated: true)
        case .edit(let id, let prefillData):
            let viewController = HangoutCreateBuilder(
                inputData: .init(
                    id: id,
                    prefillData: prefillData
                )
            ).build()
            view?.navigationController?.pushViewController(viewController, animated: true)
        case .communityDetail(let id):
            guard let vc = communitiesModule.makeCommunityDetail(communityId: id) as? UIViewController else { return }
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
