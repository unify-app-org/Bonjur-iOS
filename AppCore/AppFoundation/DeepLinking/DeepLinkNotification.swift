//
//  DeepLinkNotification.swift
//  AppFoundation
//
//  Created by Huseyn Hasanov on 10.07.26.
//

import Foundation

/// A parsed deep-link request, whatever its origin (in-app notification row,
/// custom-scheme URL, push payload). `identifier` picks the module router;
/// `action`/`payload` tell that router which screen and with what data.
public struct DeepLinkNotification {
    public typealias Payload = [AnyHashable: Any]

    public let messageId: String?
    public let identifier: String
    public let action: String?
    public var payload: Payload?
    public let title: String?
    public let subtitle: String?

    public init(
        messageId: String? = nil,
        identifier: String,
        action: String? = nil,
        payload: Payload? = nil,
        title: String? = nil,
        subtitle: String? = nil
    ) {
        self.messageId = messageId
        self.identifier = identifier
        self.action = action
        self.payload = payload
        self.title = title
        self.subtitle = subtitle
    }
}
