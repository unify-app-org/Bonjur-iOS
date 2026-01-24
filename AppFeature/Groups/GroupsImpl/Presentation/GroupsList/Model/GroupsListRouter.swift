//
//  GroupsListRouter.swift
//  GroupsImpl
//
//  Created by Huseyn Hasanov on 23.01.26.
//

import UIKit

enum GroupsListRoute {
}

protocol GroupsListRouterProtocol {
    @MainActor
    func navigate(to route: GroupsListRoute)
}

final class GroupsListRouter: GroupsListRouterProtocol {
    weak var view: UIViewController?
    
    @MainActor
    func navigate(to route: GroupsListRoute) {
    }
}
