//
//  EventCreateRouter.swift
//  EventsImpl
//
//  Created by Huseyn Hasanov on 21.02.26.
//

import UIKit

enum EventCreateRoute {
}

protocol EventCreateRouterProtocol {
    @MainActor
    func navigate(to route: EventCreateRoute)
}

final class EventCreateRouter: EventCreateRouterProtocol {
    weak var view: UIViewController?
    
    @MainActor
    func navigate(to route: EventCreateRoute) {
    }
}
