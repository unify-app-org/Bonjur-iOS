// 
//  ModuleImpl.swift
//  Discover
//
//  Created by Huseyn Hasanov on 11.01.26.
//

import Foundation
import Discover

protocol DiscoverDeleagete {
    func viewAllClubs()
}

class DiscoverModuleImpl: DiscoverModule, DiscoverDeleagete {
    weak var moduleDeleagete: DiscoverModuleDeleagete?
    
    public init() {}
    
    func makeDiscover(
        _ delelegate: DiscoverModuleDeleagete
    ) -> AnyObject {
        moduleDeleagete = delelegate
        return DiscoverBuilder(
            inputData: .init()
        ).build()
    }
    
    func viewAllClubs() {
        moduleDeleagete?.viewAllClubs()
    }
}
