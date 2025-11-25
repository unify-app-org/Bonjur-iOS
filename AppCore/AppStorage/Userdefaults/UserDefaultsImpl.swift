//
//  UserDefaultsImpl.swift
//  AppCore
//
//  Created by Huseyn Hasanov on 24.11.25.
//

import Foundation

public protocol UserDefaultsProtocol {
    func set(_ value: Any?, forKey key: UserDefultsKeys)
    
    func string(forKey key: UserDefultsKeys) -> String?
    func bool(forKey key: UserDefultsKeys) -> Bool
    func integer(forKey key: UserDefultsKeys) -> Int
    
    func remove(forKey key: UserDefultsKeys)
}

public final class UserDefaultsImpl: UserDefaultsProtocol {

    private let defaults: UserDefaults
    
    public init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }
    
    public func set(_ value: Any?, forKey key: UserDefultsKeys) {
        defaults.set(value, forKey: key.rawValue)
    }
    
    public func string(forKey key: UserDefultsKeys) -> String? {
        defaults.string(forKey: key.rawValue)
    }
    
    public func bool(forKey key: UserDefultsKeys) -> Bool {
        defaults.bool(forKey: key.rawValue)
    }
    
    public func integer(forKey key: UserDefultsKeys) -> Int {
        defaults.integer(forKey: key.rawValue)
    }
    
    public func remove(forKey key: UserDefultsKeys) {
        defaults.removeObject(forKey: key.rawValue)
    }
}
