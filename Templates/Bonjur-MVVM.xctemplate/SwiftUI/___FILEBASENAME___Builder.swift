//___FILEHEADER___

import UIKit

// MARK: - ___VARIABLE_moduleName___ builder

struct ___VARIABLE_moduleName___Builder {
    private let inputData: ___VARIABLE_moduleName___InputData
    
    init(inputData: ___VARIABLE_moduleName___InputData) {
        self.inputData = inputData
    }
    
    func build() -> UIViewController {
        let router = ___VARIABLE_moduleName___Router()
        let viewModel = ___VARIABLE_moduleName___ViewModel(
            state: .init(),
            router: router,
            inputData: inputData,
            dependencies: .init()
        )
        
        let controller = ___VARIABLE_moduleName___HostController(
            viewModel: viewModel
        ) { store in
            ___VARIABLE_moduleName___View(store: store)
        }
        
        router.view = controller
        return controller
    }
}
