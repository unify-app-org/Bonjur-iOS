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
    let snapshot: UserCardWidgetSnapshot
    let avatar: UIImage?
    /// `false` until the app has written a real snapshot — the widget then
    /// renders sample data behind a "open Unify" hint instead of blanks.
    let isSignedIn: Bool
}

struct UserCardProvider: TimelineProvider {

    func placeholder(in context: Context) -> UserCardEntry {
        UserCardEntry(
            date: Date(),
            snapshot: .placeholder,
            avatar: nil,
            isSignedIn: false
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
            snapshot: stored ?? .placeholder,
            avatar: avatarData.flatMap(UIImage.init(data:)),
            isSignedIn: stored != nil
        )
    }
}
