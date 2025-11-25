//
//  Extension+Optional.swift
//  AppCore
//
//  Created by Huseyn Hasanov on 24.11.25.
//

import Foundation

public extension Double? {
    var orZero: Double {
        self ?? 0.0
    }
}

public extension Int? {
    var orZero: Int {
        self ?? 0
    }
}

public extension CGFloat? {
    var orZero: CGFloat {
        self ?? 0.0
    }
}

public extension Float? {
    var orZero: Float {
        self ?? 0.0
    }
}


public extension String? {
    var orEmpty: String {
        self ?? ""
    }
    var isNilOrEmpty: Bool {
        self == nil || self == ""
    }
}

public extension NSString? {
    var orEmpty: NSString {
        self ?? ""
    }
    var isNilOrEmpty: Bool {
        self == nil || self == ""
    }
}

extension Optional: AnyOptional {
    public var isNil: Bool { self == nil }
}

public protocol AnyOptional {
    var isNil: Bool { get }
}
