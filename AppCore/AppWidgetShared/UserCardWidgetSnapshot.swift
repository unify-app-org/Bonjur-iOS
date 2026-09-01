//
//  UserCardWidgetSnapshot.swift
//  AppWidgetShared
//
//  Created by Huseyn Hasanov on 01.09.26.
//

import Foundation

/// The slice of the user card the home-screen widget renders.
///
/// The widget process has no session and cannot call the API, so the app
/// writes this snapshot into the shared App Group every time it loads the
/// signed-in user's profile and the widget only ever reads it.
public struct UserCardWidgetSnapshot: Codable, Equatable {
    public let userId: String
    public let nameSurname: String
    public let speciality: String
    public let course: String
    public let community: String
    public let degree: String
    public let entryYear: String
    public let email: String
    /// Raw `AppPresentationModel.BackgroundType` value ("GREEN", "BLUE", …) — the cover
    /// the user picked for their card. `nil` = the plain white card.
    /// Optional so snapshots written before this field decode instead of failing.
    public let background: String?
    public let updatedAt: Date

    public init(
        userId: String,
        nameSurname: String,
        speciality: String,
        course: String,
        community: String,
        degree: String,
        entryYear: String,
        email: String,
        background: String?,
        updatedAt: Date = Date()
    ) {
        self.userId = userId
        self.nameSurname = nameSurname
        self.speciality = speciality
        self.course = course
        self.community = community
        self.degree = degree
        self.entryYear = entryYear
        self.email = email
        self.background = background
        self.updatedAt = updatedAt
    }
}

public extension UserCardWidgetSnapshot {
    /// Shown in the widget gallery and before the user has ever opened Profile.
    static let placeholder = UserCardWidgetSnapshot(
        userId: "",
        nameSurname: "Huseyn Hasanov",
        speciality: "Oil-gas engineering",
        course: "2nd year",
        community: "UFAZ",
        degree: "Bachelor",
        entryYear: "2025",
        email: "h.hasanov@unify.com",
        background: "GREEN"
    )

    /// `"Speciality · 2nd year"`, skipping whichever half is missing.
    var subtitle: String {
        [speciality, course]
            .filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
            .joined(separator: " · ")
    }
}
