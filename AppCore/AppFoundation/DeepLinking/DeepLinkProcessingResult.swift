//
//  DeepLinkProcessingResult.swift
//  AppFoundation
//
//  Created by Huseyn Hasanov on 10.07.26.
//

public enum DeepLinkProcessingResult {
    case process(isAuthenticationRequired: Bool)
    case none
}
