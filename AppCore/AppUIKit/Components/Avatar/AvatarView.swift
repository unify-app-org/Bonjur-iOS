//
//  AvatarView.swift
//  AppFoundation
//
//  Created by Huseyn Hasanov on 11.05.26.
//

import SwiftUI

public struct AvatarView: View {

    private let image: UIImage?
    private let url: URL?
    private var placeholder: AnyView? = nil

    public init<Placeholder: View>(
        image: UIImage? = nil,
        url: URL?,
        @ViewBuilder placeholder: () -> Placeholder = { EmptyView() }
    ) {
        self.image = image
        self.url = url
        self.placeholder = AnyView(placeholder())
    }

    public var body: some View {
        imageView
        .frame(width: 88, height: 88)
        .background(Color.Palette.grayQuaternary)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(
                    Color.Palette.grayTeritary.opacity(0.3),
                    lineWidth: 3
                )
        )
        .padding(.horizontal, 16)
    }

    @ViewBuilder
    private var imageView: some View {
        if let image {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
        } else {
            CachedAsyncImage(url: url) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                placeholder
            }
        }
    }
}
