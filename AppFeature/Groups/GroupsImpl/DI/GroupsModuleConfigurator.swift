// 
//  GroupsModuleConfigurator.swift
//  Groups
//
//  Created by Huseyn Hasanov on 23.01.26.
//

import Foundation
import DependecyInjection

public class GroupsConfigurator {
    
    public init() {}

    public static func setup(
        diContainer: AppDIContainer
    ) {
        GroupsDependencyContainer.setup(container: diContainer)
    }
}
