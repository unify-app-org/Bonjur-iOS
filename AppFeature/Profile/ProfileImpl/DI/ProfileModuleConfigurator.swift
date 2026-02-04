// 
//  ProfileModuleConfigurator.swift
//  Profile
//
//  Created by Huseyn Hasanov on 04.02.26.
//

import Foundation
import DependecyInjection

public class ProfileConfigurator {
    
    public init() {}

    public static func setup(
        diContainer: AppDIContainer
    ) {
        ProfileDependencyContainer.setup(container: diContainer)
    }
}
