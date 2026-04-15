//
//  FloatingDockModel.swift
//  App
//
//  Created by Codex on 15.04.26.
//

import Combine

enum FloatingDockMode {
    case home
    case away
}

final class FloatingDockModel: ObservableObject {
    
    @Published var mode: FloatingDockMode = .home
    @Published var joinedEventsCount: Int = 0
    @Published var joinedHangoutsCount: Int = 0
    @Published var isVisible = true
    @Published var isActivitiesPresented = false
    @Published var isCreatePresented = false
    
    var badgeCount: Int {
        joinedEventsCount + joinedHangoutsCount
    }
}
