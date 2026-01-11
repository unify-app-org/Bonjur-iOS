// 
//  DiscoverModuleConfigurator.swift
//  Discover
//
//  Created by Huseyn Hasanov on 11.01.26.
//

import Foundation
import DependecyInjection

public class DiscoverConfigurator {
    
    public init() {}

    public static func setup(
        diContainer: AppDIContainer
    ) {
        DiscoverDependencyContainer.setup(container: diContainer)
    }
}
