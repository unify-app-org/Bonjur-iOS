//
//  MembersListHostController.swift
//  CommunitiesImpl
//
//  Created by Claude on 15.06.26.
//

import UIKit
import AppFoundation

// MARK: - Controller

final class MembersListHostController: UIFeatureController<
    MembersListFeature,
    MembersListView
> {
    override func viewDidLoad() {
        super.viewDidLoad()
        hidesBottomBarWhenPushed = true
    }
    
    override func handleEffect(_ effect: MembersListSideEffect) {
        switch effect {
        case .loading:
            break
        }
    }
}
