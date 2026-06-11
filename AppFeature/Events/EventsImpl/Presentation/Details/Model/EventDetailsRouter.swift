//
//  EventDetailsRouter.swift
//  EventsImpl
//
//  Created by Huseyn Hasanov on 01.02.26.
//

import UIKit

enum EventDetailsRoute {
    case backTapped
    case editEvent(id: String, prefillData: EventsCreate.PrefillData)
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
        case .editEvent(let id, let prefillData):
            let vc = EventCreateBuilder(
                inputData: .init(
                    eventId: id,
                    prefillData: prefillData
                )
            ).build()
            view?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
