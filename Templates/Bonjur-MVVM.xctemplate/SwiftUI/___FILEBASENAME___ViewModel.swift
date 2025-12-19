//___FILEHEADER___

import AppFoundation

final class ___VARIABLE_moduleName___ViewModel: UIFeatureViewModel<___VARIABLE_moduleName___Feature> {
    
    struct Dependencies {
    }
    
    private let router: ___VARIABLE_moduleName___RouterProtocol
    private let inputData: ___VARIABLE_moduleName___InputData
    private let dependencies: ___VARIABLE_moduleName___ViewModel.Dependencies
    
    init(
        state: ___VARIABLE_moduleName___Feature.State,
        router: ___VARIABLE_moduleName___RouterProtocol,
        inputData: ___VARIABLE_moduleName___InputData,
        dependencies: ___VARIABLE_moduleName___ViewModel.Dependencies
    ) {
        self.router = router
        self.inputData = inputData
        self.dependencies = dependencies
        super.init(initialState: state)
    }
    
    override func handle(action: ___VARIABLE_moduleName___Feature.Action) {
    }
    
    private func fetchData() {
        
    }
}
