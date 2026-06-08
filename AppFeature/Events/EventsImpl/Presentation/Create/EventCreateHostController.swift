//
//  EventCreateHostController.swift
//  EventsImpl
//
//  Created by Huseyn Hasanov on 21.02.26.
//

import UIKit
import AppUIKit
import AppFoundation

// MARK: - Controller

final class EventCreateHostController: UIFeatureController<
    EventCreateFeature,
    EventCreateView
> {

    override func viewDidLoad() {
        super.viewDidLoad()
        hidesBottomBarWhenPushed = true
    }

    override func handleEffect(_ effect: EventCreateSideEffect) {
        switch effect {
        case .loading(let isLoading):
            if isLoading {
                AppLoadingUI.show()
            } else {
                AppLoadingUI.dismiss()
            }
        }
    }
}
