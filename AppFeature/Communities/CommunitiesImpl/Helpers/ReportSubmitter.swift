//
//  ReportSubmitter.swift
//  CommunitiesImpl
//
//  Sends a report through the shared `ReportService` (POST api/us/v1/users/reports)
//  and shows the outcome. Each report sheet closes only when this returns `true`.
//

import AppNetwork
import AppUIKit
import AppPresentationModel

enum ReportSubmitter {

    /// Reporting a club / event / hangout.
    static func submit(
        _ target: ReportTarget,
        reason: AppPresentationModel.ActivityReportReason,
        successTitle: String
    ) async -> Bool {
        await submit(target, code: reason.rawValue, details: reason.displayTitle, successTitle: successTitle)
    }

    /// Reporting a member.
    static func submit(
        _ target: ReportTarget,
        reason: AppPresentationModel.ReportReason,
        successTitle: String
    ) async -> Bool {
        await submit(target, code: reason.rawValue, details: reason.displayTitle, successTitle: successTitle)
    }

    private static func submit(
        _ target: ReportTarget,
        code: String,
        details: String,
        successTitle: String
    ) async -> Bool {
        let service: ReportService = resolve()
        do {
            try await service.report(target, reason: code, details: details)
            await MainActor.run { AppSnackBar.show(title: successTitle, style: .success) }
            return true
        } catch {
            await MainActor.run {
                AppSnackBar.show(title: APIError.popupTitle, subtitle: error.popupSubtitle, style: .error)
            }
            return false
        }
    }
}
