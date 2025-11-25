//
//  AppEnviroment.swift
//  AppCore
//
//  Created by Huseyn Hasanov on 24.11.25.
//

import Foundation

public struct AppEnviroment {
    
    public enum EnviromentType: String {
        case test, prod
    }
    public static var current: EnviromentType {
        let rawValue = (Bundle.main.object(forInfoDictionaryKey: "Environment") as? String ?? "").lowercased()
        return EnviromentType(rawValue: rawValue) ?? .prod
    }
    
    public static var baseURL: String {
        return Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String ?? ""
    }
}
