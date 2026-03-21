//
//  MemberBrowseRouter.swift
//  CommunitiesImpl
//
//  Created by aplle on 3/21/26.
//

import UIKit

enum MemberBrowseRoute {
}

protocol MemberBrowseRouterProtocol {
    @MainActor
    func navigate(to route: MemberBrowseRoute)
}

final class MemberBrowseRouter: MemberBrowseRouterProtocol {
    weak var view: UIViewController?
    
    @MainActor
    func navigate(to route: MemberBrowseRoute) {
    }
}
