//
//  EventCreateRouter.swift
//  EventsImpl
//
//  Created by Huseyn Hasanov on 21.02.26.
//

import UIKit
import Clubs

enum EventCreateRoute {
    case backTapped
    case createClub
    case browseClubs
}

protocol EventCreateRouterProtocol {
    @MainActor
    func navigate(to route: EventCreateRoute)
}

final class EventCreateRouter: EventCreateRouterProtocol {
    weak var view: UIViewController?
    private let clubsModule: ClubsModule

    init(clubsModule: ClubsModule = resolve()) {
        self.clubsModule = clubsModule
    }

    @MainActor
    func navigate(to route: EventCreateRoute) {
        switch route {
        case .backTapped:
            self.view?.navigationController?.popViewController(animated: true)
        case .createClub:
            guard let vc = clubsModule.makeCreateVC() as? UIViewController else { return }
            view?.navigationController?.pushViewController(vc, animated: true)
        case .browseClubs:
            guard let vc = clubsModule.makeClubsViewController() as? UIViewController else { return }
            view?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
