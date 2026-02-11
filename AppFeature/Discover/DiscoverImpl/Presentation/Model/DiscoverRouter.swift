//
//  DiscoverRouter.swift
//  DiscoverImpl
//
//  Created by Huseyn Hasanov on 11.01.26.
//

import UIKit
import Events
import Hangouts
import Clubs
import Communities

enum DiscoverRoute {
    case viewAllClubs
    case viewAllEvents
    case viewAllHangouts
    case clubsDetails(id: Int)
    case eventsDetails(id: String)
    case hangoutsDetails(id: String)
    case communityDetails(id: Int)
}

protocol DiscoverRouterProtocol {
    @MainActor
    func navigate(to route: DiscoverRoute)
}

final class DiscoverRouter: DiscoverRouterProtocol {
    weak var view: UIViewController?
    private var delegate: DiscoverDelegate
    private var eventModule: EventsModule
    private var hangoutModule: HangoutsModule
    private var clubModule: ClubsModule
    private var communityModule: CommunitiesModule

    init(
        view: UIViewController? = nil,
        delegate: DiscoverDelegate = resolve(),
        eventModule: EventsModule = resolve(),
        hangoutModule: HangoutsModule = resolve(),
        clubModule: ClubsModule = resolve(),
        communityModule: CommunitiesModule = resolve()
    ) {
        self.view = view
        self.delegate = delegate
        self.eventModule = eventModule
        self.hangoutModule = hangoutModule
        self.clubModule = clubModule
        self.communityModule = communityModule
    }
    
    @MainActor
    func navigate(to route: DiscoverRoute) {
        switch route {
        case .viewAllClubs:
            delegate.viewAllClubs()
        case .viewAllEvents:
            let vc = eventModule.makeEventsList() as! UIViewController
            vc.hidesBottomBarWhenPushed = true
            view?.navigationController?.pushViewController(vc, animated: true)
        case .viewAllHangouts:
            let vc = hangoutModule.makeHangoutsList() as! UIViewController
            vc.hidesBottomBarWhenPushed = true
            view?.navigationController?.pushViewController(vc, animated: true)
        case .clubsDetails(let clubId):
            let vc = clubModule.makeClubsDetailsVC(clubId: clubId) as! UIViewController
            vc.hidesBottomBarWhenPushed = true
            self.view?.navigationController?.pushViewController(vc, animated: true)
        case .eventsDetails(let id):
            let vc = eventModule.makeEventsDetails(eventId: id) as! UIViewController
            vc.hidesBottomBarWhenPushed = true
            self.view?.navigationController?.pushViewController(vc, animated: true)
        case .hangoutsDetails(let id):
            let vc = hangoutModule.makeHangoutDetails(hangoutId: id) as! UIViewController
            vc.hidesBottomBarWhenPushed = true
            self.view?.navigationController?.pushViewController(vc, animated: true)
        case .communityDetails(let id):
            let vc = communityModule.makeCommunityDetail(communityId: id) as! UIViewController
            vc.hidesBottomBarWhenPushed = true
            self.view?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
