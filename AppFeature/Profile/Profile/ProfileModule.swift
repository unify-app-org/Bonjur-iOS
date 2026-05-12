// 
//  ProfileModule.swift
//  Profile
//
//  Created by Huseyn Hasanov on 04.02.26.
//

import Foundation
import AppPresentationModel

public protocol ProfileModule {
    func makeProfileViewController(
        userId: String
    ) -> AnyObject
}

public protocol ProfileDelegate: AnyObject {
    func logout()
}
