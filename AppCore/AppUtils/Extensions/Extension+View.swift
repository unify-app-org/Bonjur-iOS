//
//  Extension+View.swift
//  AppCore
//
//  Created by Huseyn Hasanov on 11.01.26.
//

import SwiftUI

public extension View {
    
    func makeUIView() -> UIView {
        let hostingController = UIHostingController(rootView: self)
        hostingController.view.backgroundColor = .clear
        return hostingController.view
    }
    
    @ViewBuilder
    func applyGlassIfAvailable() -> some View {
        if #available(iOS 26.0, *) {
            self.glassEffect()
        } else {
            self
        }
    }
}

public extension ToolbarContent {
    @ToolbarContentBuilder
    func applySharedBackgroundVisibilityIfAvailable(_ visibility: Visibility) -> some ToolbarContent {
        if #available(iOS 26.0, *) {
            self.sharedBackgroundVisibility(visibility)
        } else {
            self
        }
    }
}
