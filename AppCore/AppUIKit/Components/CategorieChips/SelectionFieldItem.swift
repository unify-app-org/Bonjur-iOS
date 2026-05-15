//
//  SelectionFieldItem.swift
//  AppUIKit
//
//  Created by Cursor on 15.05.26.
//

import Foundation

public struct SelectionFieldItem: Identifiable, Hashable {
    public let id: Int
    public let title: String
    
    public init(
        id: Int,
        title: String
    ) {
        self.id = id
        self.title = title
    }
}
