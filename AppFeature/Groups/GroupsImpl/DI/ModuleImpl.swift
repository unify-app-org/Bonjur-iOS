// 
//  ModuleImpl.swift
//  Groups
//
//  Created by Huseyn Hasanov on 23.01.26.
//

import Foundation
import Groups

struct GroupsModuleImpl: GroupsModule {
    
    func makeGroups(inputData: GroupsModuleModel.InputData) -> AnyObject {
        GroupsListBuilder(
            inputData: .init(onDismiss: inputData.onDismiss)
        ).build()
    }
}
