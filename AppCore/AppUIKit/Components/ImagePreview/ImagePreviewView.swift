//
//  ImagePreviewView.swift
//  AppUIKit
//
//  Created by Huseyn Hasanov on 01.09.26.
//

import SwiftUI
import AppLocalization

/// Full-screen photo viewer: pinch / double-tap to zoom, pan while zoomed,
/// drag down to dismiss. Presented by `.imagePreview(url:)`.
public struct ImagePreviewView: View {
    private let url: URL?

    @Environment(\.dismiss) private var dismiss

    @State private var scale: CGFloat = 1
    @State private var lastScale: CGFloat = 1
    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero
    @State private var dragDown: CGFloat = 0

    private let maxScale: CGFloat = 4
    private let doubleTapScale: CGFloat = 2.5
    private let dismissDistance: CGFloat = 120

    public init(url: URL?) {
        self.url = url
    }

    private var isZoomed: Bool { scale > 1.01 }

    public var body: some View {
        ZStack {
            Color.black
                .opacity(backdropOpacity)
                .ignoresSafeArea()

            imageView
                .scaleEffect(scale)
                .offset(
                    x: offset.width,
                    y: offset.height + dragDown
                )
                .gesture(magnification)
                .simultaneousGesture(drag)
                .onTapGesture(count: 2) { toggleZoom() }

            closeButton
        }
        .statusBarHidden()
    }

    @ViewBuilder
    private var imageView: some View {
        CachedAsyncImage(url: url) { image in
            image
                .resizable()
                .scaledToFit()
        } placeholder: {
            ProgressView()
                .tint(Color.Palette.white)
        }
    }

    private var closeButton: some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(Color.Palette.white)
                        .padding(12)
                        .background(Color.black.opacity(0.45))
                        .clipShape(Circle())
                }
                .accessibilityLabel("image_preview_close".localized)
            }
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .opacity(isZoomed ? 0 : 1)
        .animation(.easeInOut(duration: 0.15), value: isZoomed)
    }

    /// Fades the backdrop out as the drag-to-dismiss travels, so the photo
    /// visibly detaches from the screen underneath it.
    private var backdropOpacity: Double {
        let progress = min(abs(dragDown) / (dismissDistance * 2), 0.6)
        return 1 - Double(progress)
    }

    private var magnification: some Gesture {
        MagnificationGesture()
            .onChanged { value in
                scale = min(max(lastScale * value, 1), maxScale)
            }
            .onEnded { _ in
                lastScale = scale
                if scale <= 1.01 { resetZoom() }
            }
    }

    /// While zoomed the drag pans the photo; at 1x it arms drag-to-dismiss.
    private var drag: some Gesture {
        DragGesture()
            .onChanged { value in
                if isZoomed {
                    offset = CGSize(
                        width: lastOffset.width + value.translation.width,
                        height: lastOffset.height + value.translation.height
                    )
                } else {
                    dragDown = value.translation.height
                }
            }
            .onEnded { value in
                if isZoomed {
                    lastOffset = offset
                } else if abs(value.translation.height) > dismissDistance {
                    dismiss()
                } else {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                        dragDown = 0
                    }
                }
            }
    }

    private func toggleZoom() {
        withAnimation(.easeInOut(duration: 0.2)) {
            if isZoomed {
                resetZoom()
            } else {
                scale = doubleTapScale
                lastScale = doubleTapScale
            }
        }
    }

    private func resetZoom() {
        scale = 1
        lastScale = 1
        offset = .zero
        lastOffset = .zero
    }
}
