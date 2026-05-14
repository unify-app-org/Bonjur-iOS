//
//  ImageCache.swift
//  AppCore
//
//  Created by Huseyn Hasanov on 24.01.26.
//

import SwiftUI

public struct CachedAsyncImage<Content: View, Placeholder: View>: View {
    let url: URL?
    let content: (Image) -> Content
    let placeholder: () -> Placeholder

    @State private var image: UIImage?
    @State private var isLoading = false
    @State private var loadingURL: URL?

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
        Group {
            if let image {
                content(Image(uiImage: image))
            } else {
                placeholder()
            }
        }
        .task(id: url) {
            await load(url)
        }
    }

    @MainActor
    private func load(_ url: URL?) async {
        image = nil
        loadingURL = url
        
        guard let url else {
            isLoading = false
            return
        }

        isLoading = true

        if let cached = ImageCache.shared.object(forKey: url as NSURL) {
            image = cached
            isLoading = false
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard !Task.isCancelled, loadingURL == url else {
                return
            }

            if let uiImage = UIImage(data: data) {
                ImageCache.shared.setObject(uiImage, forKey: url as NSURL)
                image = uiImage
            }
            
            isLoading = false
        } catch {
            guard !Task.isCancelled, loadingURL == url else {
                return
            }

            isLoading = false
        }
    }
}
