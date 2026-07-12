//
//  DeepLinkContext.swift
//  AppFoundation
//
//  Created by Huseyn Hasanov on 10.07.26.
//

import UIKit

public struct DeepLinkContext {

    public static var `default`: DeepLinkContext {
        DeepLinkContext(navigationType: .default, animated: true)
    }

    public enum NavigationType {
        /// Navigate from the app's current top view controller.
        case `default`
        /// Navigate over an explicitly provided host (e.g. after dismissing a
        /// sheet, push on the presenter's navigation controller).
        case overCurrentContext(topViewController: UIViewController?)
    }

    public let navigationType: NavigationType
    public let animated: Bool

    public init(navigationType: NavigationType, animated: Bool = true) {
        self.navigationType = navigationType
        self.animated = animated
    }
}
