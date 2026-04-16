// 
//  ModuleImpl.swift
//  Discover
//
//  Created by Huseyn Hasanov on 11.01.26.
//

import Foundation
import Discover

protocol DiscoverDelegate {
    func viewAllClubs()
    func openProfile()
    func didUpdateActivityCounts(events: Int, hangouts: Int)
}

class DiscoverModuleImpl: DiscoverModule, DiscoverDelegate {
    weak var moduleDelegate: DiscoverModuleDelegate?
    
    public init() {}
    
    func makeDiscover(
        _ delegate: DiscoverModuleDelegate
    ) -> AnyObject {
        moduleDelegate = delegate
        return DiscoverBuilder(
            inputData: .init()
        ).build()
    }
    
    func viewAllClubs() {
        moduleDelegate?.viewAllClubs()
    }
    
    func openProfile() {
        moduleDelegate?.openProfile()
    }
    
    func didUpdateActivityCounts(events: Int, hangouts: Int) {
        moduleDelegate?.didUpdateActivityCounts(
            events: events,
            hangouts: hangouts
        )
    }
}
