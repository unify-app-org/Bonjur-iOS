//
//  AppEnvironment.swift
//  AppCore
//
//  Created by Huseyn Hasanov on 24.11.25.
//

import Foundation

public struct AppEnvironment {
    
    public enum EnvironmentType: String {
        case test, prod
    }
    public static var current: EnvironmentType {
        let rawValue = (Bundle.main.object(forInfoDictionaryKey: "Environment") as? String ?? "").lowercased()
        return EnvironmentType(rawValue: rawValue) ?? .prod
    }
    
    public static var baseURL: String {
        return Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String ?? ""
    }
}
