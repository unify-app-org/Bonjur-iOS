// 
//  ModuleImpl.swift
//  Notification
//
//  Created by Huseyn Hasanov on 27.06.26.
//

import UIKit
import Notification

final class NotificationModuleImpl: NotificationModule {

    public init() {}

    func makeNotification() -> AnyObject {
        NotificationBuilder(
            inputData: .init()
        ).build()
    }
}
