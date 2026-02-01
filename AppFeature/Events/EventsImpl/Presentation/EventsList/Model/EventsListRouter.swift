//
//  EventsListRouter.swift
//  EventsImpl
//
//  Created by Huseyn Hasanov on 22.01.26.
//

import UIKit

enum EventsListRoute {
    case showDetails(id: String)
}

protocol EventsListRouterProtocol {
    @MainActor
    func navigate(to route: EventsListRoute)
}

final class EventsListRouter: EventsListRouterProtocol {
    weak var view: UIViewController?
    
    @MainActor
    func navigate(to route: EventsListRoute) {
        switch route {
        case .showDetails(let id):
            let vc = EventDetailsBuilder(
                inputData: .init(
                    eventId: id
                )
            ).build()
            view?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
