//
//  MemberOptions.swift
//  AppPresentationModel
//
//  Member 3-dot options menu: report reasons + role-assignment policy.
//  Pure domain rules (no UIKit/SwiftUI) so they can be unit-tested and reused
//  by both the shared options sheet and each activity's detail view models.
//

import Foundation

public extension AppPresentationModel {

    // MARK: - Report Reason

    /// Hardcoded report reasons backing the "Report user" sheet.
    /// The report API is not built yet; reasons live here until the backend
    /// provides a source of truth.
    enum ReportReason: String, Codable, Hashable, CaseIterable, Identifiable {
        case fakeProfile = "FAKE_PROFILE"
        case inappropriateProfilePicture = "INAPPROPRIATE_PROFILE_PICTURE"
        case inappropriateProfileText = "INAPPROPRIATE_PROFILE_TEXT"
        case inappropriateOffers = "INAPPROPRIATE_OFFERS"
        case offensive = "OFFENSIVE"
        case underage = "UNDERAGE"
        case scamAndCommercial = "SCAM_AND_COMMERCIAL"
        case other = "OTHER"

        public var id: String { rawValue }

        public var displayTitle: String {
            switch self {
            case .fakeProfile: return "Fake profile"
            case .inappropriateProfilePicture: return "Inappropriate profile picture"
            case .inappropriateProfileText: return "Inappropriate profile text"
            case .inappropriateOffers: return "Inappropriate offers"
            case .offensive: return "Ofensive word, threats, insults"
            case .underage: return "Underage"
            case .scamAndCommercial: return "Scam and commercial"
            case .other: return "Other"
            }
        }
    }

    // MARK: - Activity Report Reason

    /// Report reasons for an activity itself (club / event / hangout), as opposed
    /// to reporting a member. The report API is not built yet; submitting is a
    /// no-op stub at the call site until the backend provides an endpoint.
    enum ActivityReportReason: String, Codable, Hashable, CaseIterable, Identifiable {
        case inappropriateContent = "INAPPROPRIATE_CONTENT"
        case spam = "SPAM"
        case scamAndCommercial = "SCAM_AND_COMMERCIAL"
        case harassment = "HARASSMENT"
        case misleadingInfo = "MISLEADING_INFO"
        case other = "OTHER"

        public var id: String { rawValue }

        public var displayTitle: String {
            switch self {
            case .inappropriateContent: return "Inappropriate content"
            case .spam: return "Spam"
            case .scamAndCommercial: return "Scam and commercial"
            case .harassment: return "Harassment or hate speech"
            case .misleadingInfo: return "Misleading information"
            case .other: return "Other"
            }
        }
    }

    // MARK: - Member Options Policy

    /// Single source of truth for who may change roles and which roles they may
    /// grant. Both the shared options sheet and the detail view models call into
    /// this so the rules can never diverge across activities.
    enum MemberOptionsPolicy {

        /// Roles a viewer may grant to another member.
        ///
        /// - President: all assignable roles.
        /// - Vice president: only Member and Event creator — a vice president
        ///   cannot create peers (vice president) or superiors (president).
        /// - Anyone else: none.
        public static func assignableRoles(
            viewer: UserActivityRole
        ) -> [UserActivityRole] {
            switch viewer {
            case .president:
                return [.member, .president, .visePresident, .eventCreator]
            case .visePresident:
                return [.member, .eventCreator]
            case .member, .eventCreator, .notJoined:
                return []
            }
        }

        /// Whether the "Change role" row should be shown.
        /// Only clubs and communities have roles; never on your own row.
        public static func canChangeRole(
            viewer: UserActivityRole,
            activity: ActivityType,
            isSelf: Bool
        ) -> Bool {
            guard !isSelf else { return false }
            guard activity == .clubs || activity == .community else { return false }
            return !assignableRoles(viewer: viewer).isEmpty
        }

        /// Whether the "Report user" row should be shown. Everyone but yourself.
        public static func canReport(isSelf: Bool) -> Bool {
            !isSelf
        }

        /// Whether the "Report <activity>" row should be shown in the activity
        /// (club / event / hangout) options sheet. Everyone may report the
        /// activity except its creator/owner — you can't report your own.
        public static func canReportActivity(
            viewer: UserActivityRole
        ) -> Bool {
            switch viewer {
            case .president, .eventCreator:
                return false
            case .member, .visePresident, .notJoined:
                return true
            }
        }
    }
}

// MARK: - Role labels for the assign-role picker

public extension AppPresentationModel.UserActivityRole {

    /// Title shown in the assign-role picker. Differs from `displayTitle`
    /// (badge text) — e.g. event creator reads "Event organizer" here.
    var assignTitle: String {
        switch self {
        case .member: return "Member"
        case .president: return "President"
        case .visePresident: return "Vice president"
        case .eventCreator: return "Event organizer"
        case .notJoined: return ""
        }
    }

    /// Subtitle under each picker row describing the role's powers.
    var assignSubtitle: String {
        switch self {
        case .member: return "Just can view content"
        case .president: return "Can manage club"
        case .visePresident: return "Can manage club, can't assign roles"
        case .eventCreator: return "Just can create event in club"
        case .notJoined: return ""
        }
    }
}
