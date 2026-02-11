//
//  ImageCache.swift
//  AppCore
//
//  Created by Huseyn Hasanov on 24.01.26.
//

import UIKit

final class ImageCache {
    static let shared = NSCache<NSURL, UIImage>()
}
