//
//  FeatureController.swift
//  AppCore
//
//  Created by Huseyn Hasanov on 24.11.25.
//


import SwiftUI

open class UIFeatureController<Feature: UIFeature, Content: View>: UIHostingController<Content> {

    let viewModel: UIFeatureViewModel<Feature>
    public let store: StoreOf<Feature>

    public init(
        viewModel: UIFeatureViewModel<Feature>,
        @ViewBuilder content: @escaping (StoreOf<Feature>) -> Content
    ) {
        self.viewModel = viewModel
        self.store = viewModel.store
        super.init(rootView: content(viewModel.store))

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
