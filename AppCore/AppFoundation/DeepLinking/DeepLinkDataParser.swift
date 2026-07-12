//
//  DeepLinkDataParser.swift
//  AppFoundation
//
//  Created by Huseyn Hasanov on 10.07.26.
//

import Foundation

public enum DeepLinkKeys {
    public static let deepLinkKey = "deeplink"
    public static let actionKey = "action"
    public static let modelKey = "model"
    public static let messageIdKey = "message_id"
    public static let notificationTitle = "title"
    public static let notificationSubtitle = "subtitle"
}

public protocol DeepLinkDataParserProtocol {
    typealias NotificationPayload = [AnyHashable: Any]

    /// Custom-scheme URL, e.g. `bonjur://club?id=12&action=details`.
    func parseDeepLinkData(from url: URL) -> DeepLinkNotification?
    /// Flat dictionary (push payload / API response) keyed by `deeplink`.
    func parseDeepLinkDataFromDictionary(_ dictionary: NotificationPayload) -> DeepLinkNotification?
}

public final class DeepLinkDataParser: DeepLinkDataParserProtocol {

    private let deepLinksIdentifiers: [String]

    public init(deepLinksIdentifiers: [String]) {
        self.deepLinksIdentifiers = deepLinksIdentifiers
    }

    public func parseDeepLinkData(from url: URL) -> DeepLinkNotification? {
        let deepLinkType = (url.host ?? "") + url.path

        guard deepLinksIdentifiers.contains(deepLinkType) else {
            return nil
        }

        var query = url.deepLinkQueryDict
        let action = query.removeValue(forKey: DeepLinkKeys.actionKey)

        return DeepLinkNotification(
            identifier: deepLinkType,
            action: action,
            payload: query
        )
    }

    public func parseDeepLinkDataFromDictionary(
        _ dictionary: NotificationPayload
    ) -> DeepLinkNotification? {
        guard let deepLinkType = dictionary[DeepLinkKeys.deepLinkKey] as? String,
            deepLinksIdentifiers.contains(deepLinkType)
        else { return nil }

        let action = dictionary[DeepLinkKeys.actionKey] as? String
        let messageId = dictionary[DeepLinkKeys.messageIdKey] as? String
        let title = dictionary[DeepLinkKeys.notificationTitle] as? String
        let subtitle = dictionary[DeepLinkKeys.notificationSubtitle] as? String

        var payload: NotificationPayload = dictionary

        // Producers may nest data under "model" or flatten it as "model.key".
        if let model = dictionary[DeepLinkKeys.modelKey] as? NotificationPayload {
            payload = model
        } else {
            let prefix = "\(DeepLinkKeys.modelKey)."
            var dict = NotificationPayload()
            for (key, value) in dictionary {
                guard var key = key as? String, key.starts(with: prefix) else {
                    continue
                }
                key.removeFirst(prefix.count)
                dict[key] = value
            }
            if !dict.isEmpty {
                payload = dict
            }
        }

        return DeepLinkNotification(
            messageId: messageId,
            identifier: deepLinkType,
            action: action,
            payload: payload,
            title: title,
            subtitle: subtitle
        )
    }
}

private extension URL {
    var deepLinkQueryDict: [String: String] {
        let items = URLComponents(url: self, resolvingAgainstBaseURL: false)?.queryItems ?? []
        return items.reduce(into: [:]) { partialResult, item in
            partialResult[item.name] = item.value
        }
    }
}
