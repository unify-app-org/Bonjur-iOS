// 
//  HangoutsModuleConfigurator.swift
//  Hangouts
//
//  Created by Huseyn Hasanov on 17.01.26.
//

import Foundation
import DependecyInjection

public class HangoutsConfigurator {
    
    public init() {}

    public static func setup(
        diContainer: AppDIContainer
    ) {
        HangoutsDependencyContainer.setup(container: diContainer)
    }
}
