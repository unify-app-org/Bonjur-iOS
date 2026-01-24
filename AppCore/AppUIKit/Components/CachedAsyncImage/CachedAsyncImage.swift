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
    @State private var opacity: Double = 0

    public init(
        url: URL?,
        @ViewBuilder content: @escaping (Image) -> Content,
        @ViewBuilder placeholder: @escaping () -> Placeholder
    ) {
        self.url = url
        self.content = content
        self.placeholder = placeholder
        
        if let url,
           let cached = ImageCache.shared.object(forKey: url as NSURL) {
            _image = State(initialValue: cached)
        }
    }

    public var body: some View {
        Group {
            if let image {
                content(Image(uiImage: image))
                    .opacity(opacity)
            } else {
                placeholder()
            }
        }
        .task(id: url) {
            await load()
        }
    }

    private func load() async {
        guard let url else { return }

        if let cached = ImageCache.shared.object(forKey: url as NSURL) {
                image = cached
            withAnimation {
                opacity = 1
            }
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let uiImage = UIImage(data: data) {
                ImageCache.shared.setObject(uiImage, forKey: url as NSURL)
                await MainActor.run {
                    image = uiImage
                    opacity = 0
                    withAnimation {
                        opacity = 1
                    }
                }
            }
        } catch {}
    }
}
