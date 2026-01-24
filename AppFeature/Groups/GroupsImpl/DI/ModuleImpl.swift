// 
//  ModuleImpl.swift
//  Groups
//
//  Created by Huseyn Hasanov on 23.01.26.
//

import Foundation
import Groups

struct GroupsModuleImpl: GroupsModule {
    
    func makeGroups() -> AnyObject {
        GroupsListBuilder(inputData: .init()).build()
    }
}
