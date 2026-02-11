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
}
