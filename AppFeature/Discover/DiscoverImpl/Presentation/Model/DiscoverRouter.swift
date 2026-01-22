//
//  DiscoverRouter.swift
//  DiscoverImpl
//
//  Created by Huseyn Hasanov on 11.01.26.
//

import UIKit
import Events
import Hangouts

enum DiscoverRoute {
    case viewAllClubs
    case viewAllEvents
    case viewAllHangouts
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

    init(
        view: UIViewController? = nil,
        delegate: DiscoverDelegate = resolve(),
        eventModule: EventsModule = resolve(),
        hangoutModule: HangoutsModule = resolve()
    ) {
        self.view = view
        self.delegate = delegate
        self.eventModule = eventModule
        self.hangoutModule = hangoutModule
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
        }
    }
}
