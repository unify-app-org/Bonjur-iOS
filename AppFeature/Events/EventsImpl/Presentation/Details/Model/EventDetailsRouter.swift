//
//  EventDetailsRouter.swift
//  EventsImpl
//
//  Created by Huseyn Hasanov on 01.02.26.
//

import UIKit

enum EventDetailsRoute {
    case backTapped
}

protocol EventDetailsRouterProtocol {
    @MainActor
    func navigate(to route: EventDetailsRoute)
}

final class EventDetailsRouter: EventDetailsRouterProtocol {
    weak var view: UIViewController?
    
    @MainActor
    func navigate(to route: EventDetailsRoute) {
        switch route {
        case .backTapped:
            view?.navigationController?.popViewController(animated: true)
        }
    }
}
