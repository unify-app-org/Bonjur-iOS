//
//  MemberSelectionRouter.swift
//  CommunitiesImpl
//
//  Created by aplle on 3/23/26.
//

import UIKit

enum MemberSelectionRoute {
}

protocol MemberSelectionRouterProtocol {
    @MainActor
    func navigate(to route: MemberSelectionRoute)
}

final class MemberSelectionRouter: MemberSelectionRouterProtocol {
    weak var view: UIViewController?
    
    @MainActor
    func navigate(to route: MemberSelectionRoute) {
    }
}
