//
//  EventDetailsHostController.swift
//  EventsImpl
//
//  Created by Huseyn Hasanov on 01.02.26.
//

import UIKit
import AppFoundation

// MARK: - Controller

final class EventDetailsHostController: UIFeatureController<
    EventDetailsFeature,
    EventDetailsView
> {
    override func handleEffect(_ effect: EventDetailsSideEffect) {
        switch effect {
        case .loading(let isLoading):
            if isLoading {
                
            } else {
                
            }
        }
    }
}
