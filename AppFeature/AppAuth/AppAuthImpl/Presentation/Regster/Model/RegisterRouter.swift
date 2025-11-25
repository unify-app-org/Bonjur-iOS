//
//  RegisterRouter.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 25.11.25.
//

import UIKit

enum RegisterRouting {
    case otp(email: String)
}

protocol RegsiterRouter {
    func navigate(to: RegisterRouting)
}

final class RegisterRouterImpl: RegsiterRouter {
    
    weak var view: UIViewController?
    
    func navigate(to: RegisterRouting) {
        switch to {
        case .otp(email: let email):
            print("Navigate to OTP screen with email: \(email)")
        }
    }
}
