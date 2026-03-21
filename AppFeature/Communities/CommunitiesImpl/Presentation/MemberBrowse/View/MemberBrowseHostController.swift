//
//  MemberBrowseHostController.swift
//  CommunitiesImpl
//
//  Created by aplle on 3/21/26.
//

import UIKit
import AppFoundation

// MARK: - Controller

final class MemberBrowseHostController: UIFeatureController<
    MemberBrowseFeature,
    MemberBrowseView
> {
    override func handleEffect(_ effect: MemberBrowseSideEffect) {
        switch effect {
        case .loading(let isLoading):
            if isLoading {
                
            } else {
                
            }
        }
    }
}
