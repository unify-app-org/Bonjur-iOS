//
//  Extension+String.swift
//  AppCore
//
//  Created by Huseyn Hasanov on 24.11.25.
//

import Foundation

public extension String {
    func isValidPhone() -> Bool {
        let pattern = "^\\+\\d{3} \\d{2} \\d{3} \\d{2} \\d{2}$"
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        let range = NSRange(location: 0, length: utf16.count)
        return regex?.firstMatch(in: self, options: [], range: range) != nil
    }
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    
    func formatPhoneNumber() -> String {
        let digitsOnly = self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let formatted = digitsOnly.replacingOccurrences(of: "(\\d{3})(\\d{2})(\\d{3})(\\d{2})(\\d{2})", with: "+$1 $2 $3 $4 $5", options: .regularExpression, range: nil)
        return formatted
    }
}
