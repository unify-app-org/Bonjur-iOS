//
//  EventsListRouter.swift
//  EventsImpl
//
//  Created by Huseyn Hasanov on 22.01.26.
//

import UIKit

enum EventsListRoute {
}

protocol EventsListRouterProtocol {
    @MainActor
    func navigate(to route: EventsListRoute)
}

final class EventsListRouter: EventsListRouterProtocol {
    weak var view: UIViewController?
    
    @MainActor
    func navigate(to route: EventsListRoute) {
    }
}
