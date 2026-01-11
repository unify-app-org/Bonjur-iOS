// 
//  ModuleImpl.swift
//  Discover
//
//  Created by Huseyn Hasanov on 11.01.26.
//

import UIKit
import Discover

struct DiscoverModuleImpl: DiscoverModule {
    
    func makeDiscover() -> UIViewController {
        return DiscoverBuilder(
            inputData: .init()
        ).build()
    }
}
