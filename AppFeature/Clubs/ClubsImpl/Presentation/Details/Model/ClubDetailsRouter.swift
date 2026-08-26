//
//  ClubDetailsRouter.swift
//  AppAuth
//
//  Created by Huseyn Hasanov on 29.01.26.
//

import UIKit
import Profile
import Communities
import Events

enum ClubDetailsRoute {
    case backTapped
    case editClub(id: Int, prefillData: ClubsCreate.PrefillData)
    case userDetail(String)
    case eventDetail(String)
    case membersList(CommunitiesMemberModuleModel.MembersListInput)
    case createEvent
}

protocol ClubDetailsRouterProtocol {
    @MainActor
    func navigate(to route: ClubDetailsRoute)
}

final class ClubDetailsRouter: ClubDetailsRouterProtocol {
    weak var view: UIViewController?
    private let profile: ProfileModule
    private let communitiesModule: CommunitiesModule
    private let eventsModule: EventsModule

    init(
        view: UIViewController? = nil,
        profile: ProfileModule = resolve(),
        communitiesModule: CommunitiesModule = resolve(),
        eventsModule: EventsModule = resolve()
    ) {
        self.view = view
        self.profile = profile
        self.communitiesModule = communitiesModule
        self.eventsModule = eventsModule
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
            let vc = profile.makeProfileViewController(userId: id, communityId: nil) as! UIViewController
            view?.navigationController?.pushViewController(vc, animated: true)
        case .eventDetail(let id):
            guard let vc = eventsModule.makeEventsDetails(eventId: id) as? UIViewController else { return }
            view?.navigationController?.pushViewController(vc, animated: true)
        case .membersList(let input):
            guard let vc = communitiesModule.makeMembersListScreen(input: input) as? UIViewController else { return }
            view?.navigationController?.pushViewController(vc, animated: true)
        case .createEvent:
            guard let vc = eventsModule.makeCreateVC() as? UIViewController else { return }
            view?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
