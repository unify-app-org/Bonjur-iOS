//
//  SwipeBackGestureEnabler.swift
//  AppCore
//
//  Created by Huseyn Hasanov on 31.01.26.
//

import SwiftUI

struct SwipeBackGestureEnabler: UIViewControllerRepresentable {
    let isEnabled: Bool
    
    func makeUIViewController(context: Context) -> UIViewController {
        let vc = UIViewController()
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        DispatchQueue.main.async {
            if let navigationController = uiViewController.navigationController {
                navigationController.interactivePopGestureRecognizer?.isEnabled = isEnabled
                if isEnabled {
                    navigationController.interactivePopGestureRecognizer?.delegate = nil
                }
            }
        }
    }
}

public extension View {
    func enableSwipeBack(_ isEnabled: Bool = true) -> some View {
        background(SwipeBackGestureEnabler(isEnabled: isEnabled))
    }
}
