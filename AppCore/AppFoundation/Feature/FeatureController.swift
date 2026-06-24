//
//  FeatureController.swift
//  AppCore
//
//  Created by Huseyn Hasanov on 24.11.25.
//


import SwiftUI
import UIKit

/// Wraps a feature's root view and attaches a global "Done" keyboard toolbar,
/// so every SwiftUI text field on every feature screen gets a dismiss button
/// above the keyboard — no per-screen wiring.
public struct KeyboardAccessoryHost<Content: View>: View {
    let content: Content

    public var body: some View {
        // Done keyboard toolbar disabled for now. Re-enable by restoring the
        // `.toolbar { ToolbarItemGroup(placement: .keyboard) { ... } }` below.
        content
//            .toolbar {
//                ToolbarItemGroup(placement: .keyboard) {
//                    Spacer()
//                    Button("Done") {
//                        UIApplication.shared.sendAction(
//                            #selector(UIResponder.resignFirstResponder),
//                            to: nil,
//                            from: nil,
//                            for: nil
//                        )
//                    }
//                }
//            }
    }
}

open class UIFeatureController<Feature: UIFeature, Content: View>: UIHostingController<KeyboardAccessoryHost<Content>> {

    let viewModel: UIFeatureViewModel<Feature>
    public let store: StoreOf<Feature>

    public init(
        viewModel: UIFeatureViewModel<Feature>,
        @ViewBuilder content: @escaping (StoreOf<Feature>) -> Content
    ) {
        self.viewModel = viewModel
        self.store = viewModel.store
        super.init(rootView: KeyboardAccessoryHost(content: content(viewModel.store)))

        self.viewModel.effectClosure = { [weak self] effect in
            guard let self else {
                return
            }
            self.handleEffect(effect)
        }
    }

    @MainActor required dynamic public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @MainActor
    open func handleEffect(_ effect: Feature.Effect) {
    }
}
