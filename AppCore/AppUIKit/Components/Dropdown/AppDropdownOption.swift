//
//  AppDropdownOption.swift
//  AppUIKit
//
//  Created by Cursor on 15.05.26.
//

import Foundation

public struct AppDropdownOption: Identifiable, Equatable, Hashable {
    public let id: String
    public let title: String
    
    public init(id: String, title: String) {
        self.id = id
        self.title = title
    }
}
