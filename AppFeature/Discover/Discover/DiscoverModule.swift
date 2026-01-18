// 
//  DiscoverModule.swift
//  Discover
//
//  Created by Huseyn Hasanov on 11.01.26.
//

import Foundation

public protocol DiscoverModule {
    func makeDiscover(_ deleagete: DiscoverModuleDeleagete) -> AnyObject
}

public protocol DiscoverModuleDeleagete: AnyObject {
    func viewAllClubs()
}
