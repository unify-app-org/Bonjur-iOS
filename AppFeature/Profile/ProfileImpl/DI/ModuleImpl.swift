// 
//  ModuleImpl.swift
//  Profile
//
//  Created by Huseyn Hasanov on 04.02.26.
//

import Foundation
import Profile

struct ProfileModuleImpl: ProfileModule {
    
    func makeProfileViewController(
        userId: String
    ) -> AnyObject {
        ProfileDetailBuilder(
            inputData: .init(
                userId: userId
            )
        ).build()
    }
}
