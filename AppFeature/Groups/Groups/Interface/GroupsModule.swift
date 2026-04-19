// 
//  GroupsModule.swift
//  Groups
//
//  Created by Huseyn Hasanov on 23.01.26.
//

import Foundation

public protocol GroupsModule {
    func makeGroups(inputData: GroupsModuleModel.InputData) -> AnyObject
}
