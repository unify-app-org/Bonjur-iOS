//
//  AppDelegate+Navigation.swift
//  App
//
//  Created by Huseyn Hasanov on 26.12.25.
//  Copyright © 2025 Unify. All rights reserved.
//

import UIKit
import AppUIKit
import SwiftUI

extension AppDelegate {
    
   func setupGlobalNavigationAppearance() {
       let appearance = UINavigationBarAppearance()
       appearance.configureWithOpaqueBackground()
       appearance.applyGlobalBackButtonStyle()
       appearance.titleTextAttributes = [
           .foregroundColor: UIColor(Color.Palette.blackHigh)
       ]
       appearance.largeTitleTextAttributes = [
           .foregroundColor: UIColor(Color.Palette.blackHigh),
           .font: UIFont.systemFont(ofSize: 28, weight: .bold),
           .baselineOffset: 8
       ]
       let navigationBarAppearance = UINavigationBar.appearance()
       navigationBarAppearance.standardAppearance = appearance
       appearance.shadowColor = .clear
       navigationBarAppearance.scrollEdgeAppearance = appearance
       navigationBarAppearance.compactAppearance = appearance
       navigationBarAppearance.compactScrollEdgeAppearance = appearance
       navigationBarAppearance.tintColor = UIColor(Color.Palette.blackHigh)

       UINavigationBarAppearanceConfigurator.applyGlobalBackButtonImage(to: navigationBarAppearance)
       UINavigationBarAppearanceConfigurator.applyGlobalBackButtonTitleOffset()
   }
}

enum NavigationBarAppearanceGlobal {
    static let backTitleOffset = UIOffset(horizontal: -1000, vertical: 0)
    
    static var backImage: UIImage {
        UIImage.Icons.arrowLeft01.withAlignmentRectInsets(
            .init(top: 0, left: -8, bottom: 4.3, right: 0)
        ).withRenderingMode(.alwaysTemplate)
    }
    
    static func makeBackButtonAppearance() -> UIBarButtonItemAppearance {
        let backButtonAppearance = UIBarButtonItemAppearance(style: .plain)
        backButtonAppearance.normal.titlePositionAdjustment = backTitleOffset
        backButtonAppearance.highlighted.titlePositionAdjustment = backTitleOffset
        backButtonAppearance.disabled.titlePositionAdjustment = backTitleOffset
        backButtonAppearance.focused.titlePositionAdjustment = backTitleOffset
        return backButtonAppearance
    }
}

public extension UINavigationBarAppearance {
    func applyGlobalBackButtonStyle() {
        let backImage = NavigationBarAppearanceGlobal.backImage
        setBackIndicatorImage(backImage, transitionMaskImage: backImage)
        backButtonAppearance = NavigationBarAppearanceGlobal.makeBackButtonAppearance()
    }
}

public enum UINavigationBarAppearanceConfigurator {
    public static func applyGlobalBackButtonTitleOffset() {
        let offset = NavigationBarAppearanceGlobal.backTitleOffset
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(offset, for: .default)
    }
    
    public static func applyGlobalBackButtonImage(to navigationBar: UINavigationBar) {
        let backImage = NavigationBarAppearanceGlobal.backImage
        navigationBar.backIndicatorImage = backImage
        navigationBar.backIndicatorTransitionMaskImage = backImage
    }
}
