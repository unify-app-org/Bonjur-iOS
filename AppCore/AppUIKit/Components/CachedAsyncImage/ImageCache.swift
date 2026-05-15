//
//  ImageCache.swift
//  AppCore
//
//  Created by Huseyn Hasanov on 24.01.26.
//

import UIKit

final class ImageCache {
    static let shared = NSCache<NSURL, UIImage>()
    
    private static let failedURLs = NSCache<NSURL, NSDate>()
    private static let failureRetryInterval: TimeInterval = 60
    
    static func hasRecentFailure(forKey key: NSURL) -> Bool {
        guard let failureDate = failedURLs.object(forKey: key) else {
            return false
        }
        
        let isRecent = abs(failureDate.timeIntervalSinceNow) < failureRetryInterval
        if !isRecent {
            failedURLs.removeObject(forKey: key)
        }
        return isRecent
    }
    
    static func markFailure(forKey key: NSURL) {
        failedURLs.setObject(NSDate(), forKey: key)
    }
    
    static func clearFailure(forKey key: NSURL) {
        failedURLs.removeObject(forKey: key)
    }
}
