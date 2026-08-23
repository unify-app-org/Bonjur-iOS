//
//  MemberOptions.swift
//  AppPresentationModel
//
//  Member 3-dot options menu: report reasons + role-assignment policy.
//  Pure domain rules (no UIKit/SwiftUI) so they can be unit-tested and reused
//  by both the shared options sheet and each activity's detail view models.
//

import AppLocalization
import Foundation

/// Anchor class so the app can register this framework's bundle with
/// `AppLocalizationProtocol.registerBundle` — enums can't be used with
/// `Bundle(for:)`.
public final class AppPresentationModelBundleToken {}

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
            case .fakeProfile: return "report_reason_fake_profile".localized
            case .inappropriateProfilePicture: return "report_reason_inappropriate_profile_picture".localized
            case .inappropriateProfileText: return "report_reason_inappropriate_profile_text".localized
            case .inappropriateOffers: return "report_reason_inappropriate_offers".localized
            case .offensive: return "report_reason_offensive".localized
            case .underage: return "report_reason_underage".localized
            case .scamAndCommercial: return "report_reason_scam_and_commercial".localized
            case .other: return "report_reason_other".localized
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
            case .inappropriateContent: return "activity_report_reason_inappropriate_content".localized
            case .spam: return "activity_report_reason_spam".localized
            case .scamAndCommercial: return "activity_report_reason_scam_and_commercial".localized
            case .harassment: return "activity_report_reason_harassment".localized
            case .misleadingInfo: return "activity_report_reason_misleading_info".localized
            case .other: return "activity_report_reason_other".localized
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
                return [.member, .visePresident, .eventCreator]
            case .visePresident:
                return [.member, .eventCreator]
            case .member, .eventCreator, .notJoined, .requested:
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
            case .member, .visePresident, .notJoined, .requested:
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
        case .member: return "role_assign_title_member".localized
        case .president: return "role_assign_title_president".localized
        case .visePresident: return "role_assign_title_vice_president".localized
        case .eventCreator: return "role_assign_title_event_creator".localized
        case .notJoined, .requested: return ""
        }
    }

    /// Subtitle under each picker row describing the role's powers.
    var assignSubtitle: String {
        switch self {
        case .member: return "role_assign_subtitle_member".localized
        case .president: return "role_assign_subtitle_president".localized
        case .visePresident: return "role_assign_subtitle_vice_president".localized
        case .eventCreator: return "role_assign_subtitle_event_creator".localized
        case .notJoined, .requested: return ""
        }
    }
}
