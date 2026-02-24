//
//  EventCreateHostController.swift
//  EventsImpl
//
//  Created by Huseyn Hasanov on 21.02.26.
//

import UIKit
import AppFoundation

// MARK: - Controller

final class EventCreateHostController: UIFeatureController<
    EventCreateFeature,
    EventCreateView
> {
    override func handleEffect(_ effect: EventCreateSideEffect) {
        switch effect {
        case .loading(let isLoading):
            if isLoading {
                
            } else {
                
            }
        }
    }
}
