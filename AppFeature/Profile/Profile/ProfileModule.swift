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

    /// Loads the signed-in user's card and publishes it to the home-screen widget's
    /// App Group when nothing has been published yet. The card is otherwise only
    /// written when the user opens their own profile, so a widget added right after
    /// signing in had nothing to show. No-op once a snapshot exists.
    func publishWidgetCardIfNeeded()
}

public protocol ProfileDelegate: AnyObject {
    func logout()
}
