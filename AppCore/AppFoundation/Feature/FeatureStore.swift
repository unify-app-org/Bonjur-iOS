//
//  FeatureStore.swift
//  AppCore
//
//  Created by Huseyn Hasanov on 24.11.25.
//

import Foundation
import Combine

public final class StoreOf<Feature: UIFeature>: ObservableObject {
    @Published public var state: Feature.State

    private var actionHandler: ((Feature.Action) -> Void)?
    private var cancellables = Set<AnyCancellable>()

    public init(state: Feature.State) {
        self.state = state

        state.objectWillChange
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                assert(Thread.isMainThread)

                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }

    func bindActionHandler(_ handler: @escaping (Feature.Action) -> Void) {
        actionHandler = handler
    }

    public func send(_ action: Feature.Action) {
        guard let actionHandler else {
            assertionFailure("UIStore action handler is not bound")
            return
        }

        actionHandler(action)
    }

    deinit {
        cancellables.removeAll()
    }
}
