//
//  AppDIContainer.swift
//  AppCore
//
//  Created by Huseyn Hasanov on 24.11.25.
//

import Foundation

public protocol AppDIContainerProtocol {
    var singletons: [String: Any] { get set }
    func register<T>(
        _ type: T.Type,
        isSingleton: Bool,
        _ factory: @escaping () -> T
    )
    func resolve<T>(_ type: T.Type) -> T
}

public class AppDIContainer: AppDIContainerProtocol {
    
    public static let shared = AppDIContainer()
    
    private var registry = [String: () -> Any]()
    public var singletons = [String: Any]()

    public init() {}
    
    public func register<T>(
        _ type: T.Type,
        isSingleton: Bool = false,
        _ factory: @escaping () -> T
    ) {
        let key = String(describing: type)
        if isSingleton {
            if singletons[key] == nil {
                singletons[key] = factory()
            }
        } else {
            registry[key] = factory
        }
    }

    public func resolve<T>(_ type: T.Type) -> T {
        let key = String(describing: type)
        if let singleton = singletons[key] as? T {
            return singleton
        }
        guard let dependency = registry[key]?() as? T else {
            fatalError("\(T.self) Dependency not found")
        }
        return dependency
    }
}
