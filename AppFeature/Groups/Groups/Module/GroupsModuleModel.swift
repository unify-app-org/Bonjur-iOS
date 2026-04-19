//
//  GroupsModuleModel.swift
//  AppFeature
//
//  Created by Huseyn Hasanov on 23.01.26.
//

import Foundation

public enum GroupsModuleModel {
    public struct InputData {
        public let onDismiss: (() -> Void)?

        public init(onDismiss: (() -> Void)? = nil) {
            self.onDismiss = onDismiss
        }
    }
}
