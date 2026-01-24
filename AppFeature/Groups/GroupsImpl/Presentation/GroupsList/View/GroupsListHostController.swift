//
//  GroupsListHostController.swift
//  GroupsImpl
//
//  Created by Huseyn Hasanov on 23.01.26.
//

import UIKit
import AppFoundation

// MARK: - Controller

final class GroupsListHostController: UIFeatureController<
    GroupsListFeature,
    GroupsListView
> {
    override func handleEffect(_ effect: GroupsListSideEffect) {
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
