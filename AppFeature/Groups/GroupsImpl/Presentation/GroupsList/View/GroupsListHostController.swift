//
//  GroupsListHostController.swift
//  GroupsImpl
//
//  Created by Huseyn Hasanov on 23.01.26.
//

import UIKit
import AppUIKit
import AppFoundation

// MARK: - Controller

final class GroupsListHostController: UIFeatureController<
    GroupsListFeature,
    GroupsListView
> {
    override func viewDidLoad() {
        super.viewDidLoad()
        hidesBottomBarWhenPushed = true
    }

    override func handleEffect(_ effect: GroupsListSideEffect) {
        switch effect {
        case .loading(let isLoading):
            if isLoading {
                AppLoadingUI.show()
            } else {
                AppLoadingUI.dismiss()
            }
        case .error(_):
            break
        }
    }
}
