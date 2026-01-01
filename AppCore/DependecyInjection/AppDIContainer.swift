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
            registry[key] = { [weak self] in
                guard let self = self else { fatalError("Container deallocated") }
                
                if let existing = self.singletons[key] {
                    guard let instance = existing as? T else {
                        fatalError("Singleton type mismatch for \(key)")
                    }
                    return instance
                }
                let instance = factory()
                self.singletons[key] = instance
                return instance
            }
        } else {
            registry[key] = factory
        }
    }

    public func resolve<T>(_ type: T.Type) -> T {
        let key = String(describing: type)
        
        guard let factory = registry[key] else {
            fatalError("\(T.self) Dependency not found")
        }
        
        guard let dependency = factory() as? T else {
            fatalError("\(T.self) Failed to cast dependency")
        }
        
        return dependency
    }
}
