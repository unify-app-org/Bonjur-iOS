//
//  CachedAsyncImage.swift
//  AppCore
//
//  Created by Huseyn Hasanov on 24.01.26.
//

import SwiftUI
import SDWebImageSwiftUI
import AppUtils

/// Async image with memory + disk caching.
///
/// SDWebImageSwiftUI is the only place it is imported — call sites keep the
/// same `content` / `placeholder` API and never reference SDWebImage directly.
public struct CachedAsyncImage<Content: View, Placeholder: View>: View {
    let url: URL?
    let content: (Image) -> Content
    let placeholder: () -> Placeholder

    public init(
        url: URL?,
        @ViewBuilder content: @escaping (Image) -> Content,
        @ViewBuilder placeholder: @escaping () -> Placeholder
    ) {
        self.url = url
        self.content = content
        self.placeholder = placeholder
    }

    public var body: some View {
        WebImage(url: resolvedURL(from: url)) { image in
            content(image)
        } placeholder: {
            placeholder()
        }
    }

    private func resolvedURL(from url: URL?) -> URL? {
        RemoteImageURL.resolved(url)
    }
}

/// Rewrites the internal `minio` host to the public base URL host. Lives apart
/// from the generic view so non-SwiftUI callers (e.g. the widget snapshot
/// writer, which downloads the avatar itself) can resolve URLs the same way.
public enum RemoteImageURL {
    public static func resolved(_ url: URL?) -> URL? {
        guard
            let url,
            url.host == "minio",
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false),
            let baseURLComponents = URLComponents(string: AppSecrets.baseURL),
            let baseHost = baseURLComponents.host
        else {
            return url
        }

        components.host = baseHost
        components.scheme = components.scheme ?? baseURLComponents.scheme
        return components.url ?? url
    }
}
