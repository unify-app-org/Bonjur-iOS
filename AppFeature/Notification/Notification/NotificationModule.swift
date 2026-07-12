// 
//  NotificationModule.swift
//  Notification
//
//  Created by Huseyn Hasanov on 27.06.26.
//

import Foundation

public protocol NotificationModule {
    func makeNotification() -> AnyObject

    /// Unread notification total for the host's bell badge.
    func fetchUnreadCount() async throws -> Int
}
