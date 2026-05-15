//
//  AppLinkItem.swift
//  AppUIKit
//
//  Created by Cursor on 15.05.26.
//

import Foundation

public struct AppLinkItem: Identifiable, Equatable, Hashable {
    public let id: UUID
    public var type: String
    public var name: String
    public var url: String
    
    public init(
        id: UUID = UUID(),
        type: String,
        name: String,
        url: String
    ) {
        self.id = id
        self.type = type
        self.name = name
        self.url = url
    }
}
