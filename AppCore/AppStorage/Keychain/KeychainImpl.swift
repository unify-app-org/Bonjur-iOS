//
//  KeychainImpl.swift
//  AppCore
//
//  Created by Huseyn Hasanov on 24.11.25.
//

import Foundation

public protocol KeychainProtocol {
    func saveString(key: KeychainKeys, value: String)
    func getString(key: KeychainKeys) -> String
    func delete(_ keys: KeychainKeys...)
}

public final class KeychainImpl: KeychainProtocol {

    public init() {}

    public func saveString(key: KeychainKeys, value: String) {
        let data = value.data(using: .utf8)!
        saveItem(key: key.rawValue, data: data)
    }

    public func getString(key: KeychainKeys) -> String {
        let data = readItem(key: key.rawValue)
        guard let data = data else { return "" }
        let string = String(data: data, encoding: .utf8)
        return string ?? ""
    }

    public func delete(_ keys: KeychainKeys...) {
        keys.forEach { deleteItem(key: $0.rawValue) }
    }

    private func readItem(key: String) -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var item: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &item)

        guard status == errSecSuccess else { return nil }

        return  item as? Data
    }

    private func saveItem(key: String, data: Data) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]

        SecItemDelete(query as CFDictionary)

        let attributes: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]

        SecItemAdd(attributes as CFDictionary, nil)
    }

    private func deleteItem(key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]

        SecItemDelete(query as CFDictionary)
    }
}
