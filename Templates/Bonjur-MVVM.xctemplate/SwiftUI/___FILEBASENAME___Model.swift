//___FILEHEADER___

import AppFoundation

// MARK: - ___VARIABLE_moduleName___ input

struct ___VARIABLE_moduleName___InputData {
}

// MARK: - Side effects

enum ___VARIABLE_moduleName___SideEffect: UISideEffect {
    case loading(Bool)
}

// MARK: - Feature Definition

typealias ___VARIABLE_moduleName___Feature = UIFeatureDefinition<
    ___VARIABLE_moduleName___ViewState,
    ___VARIABLE_moduleName___Action,
    ___VARIABLE_moduleName___SideEffect
>

// MARK: - View State

final class ___VARIABLE_moduleName___ViewState: UIFeatureState {
}

// MARK: - Feature Action

enum ___VARIABLE_moduleName___Action: UIFeatureAction {
}
