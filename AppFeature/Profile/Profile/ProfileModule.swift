// 
//  ProfileModule.swift
//  Profile
//
//  Created by Huseyn Hasanov on 04.02.26.
//

import Foundation
import AppPresentationModel

public protocol ProfileModule {
    /// [communityId] scopes the profile lookup to a community. Pass the community being
    /// viewed when opening from a community detail; omit it everywhere else so the community
    /// stored at login is used.
    func makeProfileViewController(
        userId: String?,
        communityId: Int?
    ) -> AnyObject
}

public protocol ProfileDelegate: AnyObject {
    func logout()
}
