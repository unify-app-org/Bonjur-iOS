//
//  AppEntryModulke.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 25.11.25.
//

import AppAuth
import UIKit

public final class AppAuthEntryModuleImpl: AppAuthEntryModule {
    
    public init() {}
    
    public func buildRegister() -> UIViewController {
        RegisterBuilder().build(inputData: .init())
    }
}
