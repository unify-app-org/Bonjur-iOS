//
//  MembersListRouter.swift
//  CommunitiesImpl
//
//  Created by Claude on 15.06.26.
//

import UIKit

enum MembersListRoute {
}

protocol MembersListRouterProtocol {
    @MainActor
    func navigate(to route: MembersListRoute)
}

final class MembersListRouter: MembersListRouterProtocol {
    weak var view: UIViewController?

    @MainActor
    func navigate(to route: MembersListRoute) {
    }
}
