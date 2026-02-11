// 
//  ClubsModuleConfigurator.swift
//  Clubs
//
//  Created by Huseyn Hasanov on 17.01.26.
//

import Foundation
import DependecyInjection

public class ClubsConfigurator {
    
    public init() {}

    public static func setup(
        diContainer: AppDIContainer
    ) {
        ClubsDependencyContainer.setup(container: diContainer)
    }
}
