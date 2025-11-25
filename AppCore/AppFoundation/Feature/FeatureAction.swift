//
//  FeatureAction.swift
//  AppCore
//
//  Created by Huseyn Hasanov on 24.11.25.
//


import Foundation
import Combine

public protocol UIFeatureAction {}

public protocol UIFeatureState: ObservableObject {}

public protocol UISideEffect {}

public protocol UIFeature {
    associatedtype State: UIFeatureState
    associatedtype Action: UIFeatureAction
    associatedtype Effect: UISideEffect
}

public enum UIFeatureDefinition<StateType: UIFeatureState, ActionType: UIFeatureAction, EffectType: UISideEffect>: UIFeature {
    public typealias State = StateType
    public typealias Action = ActionType
    public typealias Effect = EffectType
}
