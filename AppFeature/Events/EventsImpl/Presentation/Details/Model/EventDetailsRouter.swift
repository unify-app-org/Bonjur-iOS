//
//  EventDetailsRouter.swift
//  EventsImpl
//
//  Created by Huseyn Hasanov on 01.02.26.
//

import UIKit
import Clubs
import Profile
import Communities

enum EventDetailsRoute {
    case backTapped
    case editEvent(id: String, prefillData: EventsCreate.PrefillData)
    case clubDetail(id: Int)
    case userDetail(String)
    case membersList(CommunitiesMemberModuleModel.MembersListInput)
}

protocol EventDetailsRouterProtocol {
    @MainActor
    func navigate(to route: EventDetailsRoute)
}

final class EventDetailsRouter: EventDetailsRouterProtocol {
    weak var view: UIViewController?
    private let clubsModule: ClubsModule
    private let profile: ProfileModule
    private let communitiesModule: CommunitiesModule

    init(
        clubsModule: ClubsModule = resolve(),
        profile: ProfileModule = resolve(),
        communitiesModule: CommunitiesModule = resolve()
    ) {
        self.clubsModule = clubsModule
        self.profile = profile
        self.communitiesModule = communitiesModule
    }

    @MainActor
    func navigate(to route: EventDetailsRoute) {
        switch route {
        case .backTapped:
            view?.navigationController?.popViewController(animated: true)
        case .editEvent(let id, let prefillData):
            let vc = EventCreateBuilder(
                inputData: .init(
                    eventId: id,
                    prefillData: prefillData
                )
            ).build()
            view?.navigationController?.pushViewController(vc, animated: true)
        case .clubDetail(let id):
            guard let vc = clubsModule.makeClubsDetailsVC(clubId: id) as? UIViewController else { return }
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
