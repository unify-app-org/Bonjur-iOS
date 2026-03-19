//
//  AppAuthModule.swift
//  AppAuth
//
//  Created by Huseyn Hasanov on 24.11.25.
//

import UIKit

public protocol AppAuthModule {
    func buildOnBoarding(
        _ delegate: AppAuthModuleDelegate?
    ) -> UIViewController
}

public protocol AppAuthModuleDelegate: AnyObject {
    func appAuthModuleDidFinish()
}
