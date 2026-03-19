//
//  AppEntryModulke.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 25.11.25.
//

import AppAuth
import UIKit

protocol AuthDelegate {
    func finishAuthentication()
}

public final class AppAuthEntryModuleImpl: AppAuthModule, AuthDelegate {
    
    weak var delegate: AppAuthModuleDelegate?
    
    public init() { }
    
    public func buildOnBoarding(
        _ delegate: AppAuthModuleDelegate?
    ) -> UIViewController {
        self.delegate = delegate
        return OnboardingBuilder(inputData: .init()).build()
    }
    
    func finishAuthentication() {
        delegate?.appAuthModuleDidFinish()
    }
}
