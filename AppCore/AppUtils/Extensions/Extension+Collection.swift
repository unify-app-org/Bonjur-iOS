//
//  Extension+Collection.swift
//  AppCore
//
//  Created by Huseyn Hasanov on 24.11.25.
//

public extension Collection {
    subscript (safe index: Index) -> Element?{
        return indices.contains(index) ? self[index] : nil
    }
}
