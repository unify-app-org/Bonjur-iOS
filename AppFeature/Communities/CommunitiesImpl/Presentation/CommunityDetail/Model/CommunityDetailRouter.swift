//
//  CommunityDetailRouter.swift
//  CommunitiesImpl
//
//  Created by Huseyn Hasanov on 03.02.26.
//

import UIKit
import Clubs
import Events
import Profile
import Communities

enum CommunityDetailRoute {
    case back
    case clubsDetails(id: Int)
    /// [communityId] is the community the profile is being viewed inside — inside a
    /// community the profile is scoped to THAT community, not the one stored at login.
    case userDetails(id: String, communityId: Int)
    case edit(id: Int, prefillData: ClubsModuleModel.CreatePrefillData)
    case membersList(CommunitiesMemberModuleModel.MembersListInput)
    case createClub
    case createEvent
}

protocol CommunityDetailRouterProtocol {
    @MainActor
    func navigate(to route: CommunityDetailRoute)
}

final class CommunityDetailRouter: CommunityDetailRouterProtocol {
    weak var view: UIViewController?
    private var clubModule: ClubsModule
    private var eventsModule: EventsModule
    private var profileModule: ProfileModule
    private var communitiesModule: CommunitiesModule

    init(
        view: UIViewController? = nil,
        clubModule: ClubsModule = resolve(),
        eventsModule: EventsModule = resolve(),
        profileModule: ProfileModule = resolve(),
        communitiesModule: CommunitiesModule = resolve()
    ) {
        self.view = view
        self.clubModule = clubModule
        self.eventsModule = eventsModule
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
        case .userDetails(let id, let communityId):
            let vc = profileModule.makeProfileViewController(
                userId: id,
                communityId: communityId
            ) as! UIViewController
            view?.navigationController?.pushViewController(vc, animated: true)
        case .membersList(let input):
            guard let vc = communitiesModule.makeMembersListScreen(input: input) as? UIViewController else { return }
            view?.navigationController?.pushViewController(vc, animated: true)
        case .createClub:
            let vc = clubModule.makeCreateVC() as! UIViewController
            view?.navigationController?.pushViewController(vc, animated: true)
        case .createEvent:
            let vc = eventsModule.makeCreateVC() as! UIViewController
            view?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
