//
//  FileExtension.swift
//  Manifests
//
//  Created by Huseyn Hasanov on 19.12.25.
//


import Foundation

public enum FileExtension {
    public static let sources = "swift,h,m,intentdefinition"
    public static let images = "png,jpeg,jpg,pnga"
    
    public static func resources() -> String {
        let defaultExtensions: [String] = [
            "xib", "storyboard", "strings", "stringsdict", "xcstrings", "string", "lproj", "xcassets", "ttf", "plist", "der", "csr", "pdf", "wasticker", "xcprivacy", "gif", "json", "lottie"
        ]
        
        return defaultExtensions.joined(separator: ",")
    }
}
