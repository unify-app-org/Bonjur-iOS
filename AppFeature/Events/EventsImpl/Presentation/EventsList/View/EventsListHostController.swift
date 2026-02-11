//
//  EventsListHostController.swift
//  EventsImpl
//
//  Created by Huseyn Hasanov on 22.01.26.
//

import UIKit
import AppFoundation

// MARK: - Controller

final class EventsListHostController: UIFeatureController<
    EventsListFeature,
    EventsListView
> {
    override func handleEffect(_ effect: EventsListSideEffect) {
        switch effect {
        case .loading(let isLoading):
            if isLoading {
                
            } else {
                
            }
        case .error(_):
            break
        }
    }
}
