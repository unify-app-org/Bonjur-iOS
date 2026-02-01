//
//  GroupsListRouter.swift
//  GroupsImpl
//
//  Created by Huseyn Hasanov on 23.01.26.
//

import UIKit
import Clubs
import Events

enum GroupsListRoute {
    case clubDetail(id: Int)
    case eventDetail(id: String)
}

protocol GroupsListRouterProtocol {
    @MainActor
    func navigate(to route: GroupsListRoute)
}

final class GroupsListRouter: GroupsListRouterProtocol {
    weak var view: UIViewController?
    private var clubModule: ClubsModule
    private var eventModule: EventsModule
    
    init(
        view: UIViewController? = nil,
        clubModule: ClubsModule = resolve(),
        eventModule: EventsModule = resolve()
    ) {
        self.view = view
        self.clubModule = clubModule
        self.eventModule = eventModule
    }
    
    @MainActor
    func navigate(to route: GroupsListRoute) {
        switch route {
        case .clubDetail(let id):
            let vc = clubModule.makeClubsDetailsVC(clubId: id) as! UIViewController
            vc.hidesBottomBarWhenPushed = true
            self.view?.navigationController?.pushViewController(vc, animated: true)
        case .eventDetail(let id):
            let vc = eventModule.makeEventsDetails(eventId: id) as! UIViewController
            vc.hidesBottomBarWhenPushed = true
            self.view?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
