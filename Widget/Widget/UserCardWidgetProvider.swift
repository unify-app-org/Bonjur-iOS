//
//  UserCardWidgetProvider.swift
//  UnifyWidget
//
//  Created by Huseyn Hasanov on 01.09.26.
//

import WidgetKit
import SwiftUI
import AppWidgetShared

struct UserCardEntry: TimelineEntry {
    let date: Date
    /// `nil` until the app has published a card.
    let snapshot: UserCardWidgetSnapshot?
    let avatar: UIImage?
    /// Mirrored from the app's session flag, NOT from the snapshot: the snapshot is
    /// only written on the first own-profile load, so a freshly signed-in user has
    /// none and would otherwise be told to sign in again.
    let isSignedIn: Bool
    /// Signed in, but the card has not been loaded yet.
    var hasCard: Bool { isSignedIn && snapshot != nil }
}

struct UserCardProvider: TimelineProvider {

    func placeholder(in context: Context) -> UserCardEntry {
        UserCardEntry(
            date: Date(),
            snapshot: .placeholder,
            avatar: nil,
            isSignedIn: true
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (UserCardEntry) -> Void) {
        completion(currentEntry())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<UserCardEntry>) -> Void) {
        // Nothing here changes on a clock; the app pushes updates with
        // `reloadTimelines` after every profile load. The hourly refresh is
        // only a safety net for a widget added while the app is not running.
        let timeline = Timeline(
            entries: [currentEntry()],
            policy: .after(Date().addingTimeInterval(60 * 60))
        )
        completion(timeline)
    }

    private func currentEntry() -> UserCardEntry {
        let stored = UserCardWidgetStore.load()
        let avatarData = UserCardWidgetStore.loadAvatarData()
        return UserCardEntry(
            date: Date(),
            snapshot: stored,
            avatar: avatarData.flatMap(UIImage.init(data:)),
            isSignedIn: UserCardWidgetStore.loadSignedIn()
        )
    }
}
