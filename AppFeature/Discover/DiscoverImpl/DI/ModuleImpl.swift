// 
//  ModuleImpl.swift
//  Discover
//
//  Created by Huseyn Hasanov on 11.01.26.
//

import Foundation
import Discover

struct DiscoverModuleImpl: DiscoverModule {
    
    func makeDiscover() -> AnyObject {
        return DiscoverBuilder(
            inputData: .init()
        ).build()
    }
}
