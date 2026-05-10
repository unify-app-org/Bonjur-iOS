//
//  Extension+Encodable.swift
//  AppCore
//
//  Created by Huseyn Hasanov on 09.05.26.
//

import Foundation

public extension Encodable {
    
    /// Converts the `Encodable` instance to a `[String: String]` dictionary.
    /// - Parameter encoder: The `JSONEncoder` to use. Defaults to a standard encoder.
    /// - Returns: A dictionary representation, or `[:]` if encoding fails.
    func toDictionary(using encoder: JSONEncoder = JSONEncoder()) -> [String: String] {
        guard
            let data = try? encoder.encode(self),
            let dict = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
        else { return [:] }
        
        var result: [String: String] = [:]
        for (key, value) in dict {
            switch value {
            case is NSNull:
                // Skip nil optionals — don't include them in query params
                continue
            case let array as [Any]:
                let joined = array.map { "\($0)" }.joined(separator: ",")
                if !joined.isEmpty {
                    result[key] = joined
                }
            default:
                result[key] = "\(value)"
            }
        }
        return result
    }
    
    /// Throws version of `toDictionary` for explicit error handling.
    func asDictionary(using encoder: JSONEncoder = JSONEncoder()) throws -> [String: String] {
        let data = try encoder.encode(self)
        guard let dict = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw EncodingError.invalidValue(
                self,
                .init(codingPath: [], debugDescription: "Failed to cast JSON object to [String: Any]")
            )
        }
        var result: [String: String] = [:]
        for (key, value) in dict {
            if let array = value as? [Any] {
                result[key] = array.map { "\($0)" }.joined(separator: ",")
            } else {
                result[key] = "\(value)"
            }
        }
        return result
    }
}
