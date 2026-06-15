//
//  Extension+Date.swift
//  AppCore
//
//  Created by Huseyn Hasanov on 24.11.25.
//

import Foundation


public enum DateFormat: String {
    case yyyyMMddHHmmss = "yyyy-MM-dd HH:mm:ss"
    case yyyyMMdd = "yyyy-MM-dd"
    case ddMMyyyy = "dd-MM-yyyy"
    case ddMMyyyyHHmmss = "dd-MM-yyyy HH:mm:ss"
    case ddMMyyyyHHmm = "dd.MM.yyyy HH:mm"
    case ddMMyy = "dd.MM.yy"
    case dd_MM_yyyy = "dd.MM.yyyy"
    case HHmm = "HH:mm"
    case dMMMM = "d MMMM"
    case dMMMMYYYY = "d MMMM yyyy"
    case dMMMMyyyyHHmm = "d MMMM yyyy, HH:mm"
    case MMMyyyy = "MMM yyyy"
}

public extension String {
    func date(from: DateFormat, to: DateFormat) -> String {
        let fromFormatter = makeDateFormatter()
        fromFormatter.dateFormat = from.rawValue
        
        let toFormatter = makeDateFormatter()
        toFormatter.dateFormat = to.rawValue
        
        guard let date = fromFormatter.date(from: self) else { return "" }
        
        return toFormatter.string(from: date)
    }
    
    private func makeDateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        return formatter
    }
    
    func convertToDate(from: DateFormat) -> Date? {
        let formatter = makeDateFormatter()
        formatter.dateFormat = from.rawValue
        let date = formatter.date(from: self)
        return date
    }
}

public extension Date {

    /// Parse an ISO8601 timestamp (e.g. `2026-06-29T21:09:00Z`), tolerating fractional seconds.
    static func fromISO8601(_ value: String?) -> Date? {
        guard let value else { return nil }
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = formatter.date(from: value) {
            return date
        }
        formatter.formatOptions = [.withInternetDateTime]
        return formatter.date(from: value)
    }

    func toString(format: DateFormat) -> String {
        let formatter = makeDateFormatter()
        formatter.dateFormat = format.rawValue
        return formatter.string(from: self)
    }
    
    private func makeDateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        return formatter
    }
}
