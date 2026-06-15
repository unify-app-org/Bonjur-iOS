//
//  HangoutDetailsRouter.swift
//  HangoutsImpl
//
//  Created by Huseyn Hasanov on 02.02.26.
//

import UIKit
import Communities

enum HangoutDetailsRoute {
    case back
    case edit(id: String, prefillData: HangoutsCreate.PrefillData)
    case communityDetail(id: Int)
}

protocol HangoutDetailsRouterProtocol {
    @MainActor
    func navigate(to route: HangoutDetailsRoute)
}

final class HangoutDetailsRouter: HangoutDetailsRouterProtocol {
    weak var view: UIViewController?
    private let communitiesModule: CommunitiesModule

    init(communitiesModule: CommunitiesModule = resolve()) {
        self.communitiesModule = communitiesModule
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
        }
    }
}
