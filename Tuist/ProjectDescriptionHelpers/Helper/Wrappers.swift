//
//  Wrappers.swift
//  Manifests
//
//  Created by Huseyn Hasanov on 19.12.25.
//

import ProjectDescription

public struct BonjurTarget: Sendable {
    public let target: Target

    public var targetDependency: TargetDependency {
        .target(name: target.name)
    }

    public init(target: Target) {
        self.target = target
    }
}

public extension BonjurTarget {
    func add(
        to targets: inout [BonjurTarget],
        `if` predicate: () -> Bool = { true }
    ) -> Self {
        if predicate() {
            targets.append(self)
        }
        return self
    }
}

public extension Array where Element == BonjurTarget {
    func add(
        to targets: inout [BonjurTarget]
    ) -> Self {
        for target in self {
            targets.append(target)
        }
        return self
    }
}

public struct BonnjurPackage: Sendable {
    public let name: String
    public let package: Package

    public var targetDependency: TargetDependency {
        .package(product: name)
    }

    public init(name: String) {
        self.name = name
        self.package = .local(path: .relativeToRoot("Modules/\(name)"))
    }

    public init(name: String, url: String, requirement: Package.Requirement) {
        self.name = name
        self.package = .remote(url: url, requirement: requirement)
    }
}
