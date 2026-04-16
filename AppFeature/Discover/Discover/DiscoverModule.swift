// 
//  DiscoverModule.swift
//  Discover
//
//  Created by Huseyn Hasanov on 11.01.26.
//

import Foundation

public protocol DiscoverModule {
    func makeDiscover(_ delegate: DiscoverModuleDelegate) -> AnyObject
}

public protocol DiscoverModuleDelegate: AnyObject {
    func viewAllClubs()
    func openProfile()
    func didUpdateActivityCounts(events: Int, hangouts: Int)
}
