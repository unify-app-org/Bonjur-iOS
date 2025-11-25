//
//  FeatureViewModel.swift
//  AppCore
//
//  Created by Huseyn Hasanov on 24.11.25.
//

import Foundation

open class UIFeatureViewModel<Feature: UIFeature> {

    @MainActor var effectClosure: ((Feature.Effect) -> Void)?

    public var state: Feature.State { store.state }

    public let store: StoreOf<Feature>

    public init(initialState state: Feature.State) {
        let store = StoreOf<Feature>(state: state)
        self.store = store

        store.bindActionHandler { [weak self] action in
            guard let self else {
                return
            }
            self.handle(action: action)
        }
    }

    open func handle(action: Feature.Action) {
        fatalError("handle(action:) must be overridden in subclass")
    }

    public func postEffect(_ effect: Feature.Effect) {
        Task {
            await MainActor.run {
                effectClosure?(effect)
            }
        }
    }
}
