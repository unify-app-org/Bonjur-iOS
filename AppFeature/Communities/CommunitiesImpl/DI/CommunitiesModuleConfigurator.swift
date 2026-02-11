// 
//  CommunitiesModuleConfigurator.swift
//  Communities
//
//  Created by Huseyn Hasanov on 17.01.26.
//

import Foundation
import DependecyInjection

public class CommunitiesConfigurator {
    
    public init() {}

    public static func setup(
        diContainer: AppDIContainer
    ) {
        CommunitiesDependencyContainer.setup(container: diContainer)
    }
}
