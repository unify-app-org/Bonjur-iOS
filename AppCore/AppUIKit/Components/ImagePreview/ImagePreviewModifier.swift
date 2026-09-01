//
//  ImagePreviewModifier.swift
//  AppUIKit
//
//  Created by Huseyn Hasanov on 01.09.26.
//

import SwiftUI
import UIKit

/// Long-press-to-preview for any remote photo (avatars, covers).
///
/// The long press is deliberately a *separate* gesture from whatever tap the
/// host view already has (`PressTapButtonModifier`, `Button`, navigation):
/// `.simultaneousGesture` lets both live on the same view, so a long press
/// opens the preview while a normal tap still navigates.
public struct ImagePreviewModifier: ViewModifier {
    private let url: URL?
    private let isEnabled: Bool

    @State private var isPresented = false

    public init(url: URL?, isEnabled: Bool = true) {
        self.url = url
        self.isEnabled = isEnabled
    }

    private var canPreview: Bool {
        isEnabled && url != nil
    }

    public func body(content: Content) -> some View {
        content
            .simultaneousGesture(
                LongPressGesture(minimumDuration: 0.35)
                    .onEnded { _ in
                        guard canPreview else { return }
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        isPresented = true
                    }
            )
            .fullScreenCover(isPresented: $isPresented) {
                ImagePreviewView(url: url)
                    // The cover renders over a clear background so the
                    // drag-to-dismiss fade reveals the screen underneath.
                    .background(ClearFullScreenBackground())
            }
    }
}

public extension View {
    /// Long-press this view to open `url` full screen. No-op when `url` is nil.
    func imagePreview(url: URL?, isEnabled: Bool = true) -> some View {
        modifier(ImagePreviewModifier(url: url, isEnabled: isEnabled))
    }
}

/// `fullScreenCover` paints an opaque system background by default; this
/// clears the hosting view's backing so the preview can fade its own backdrop.
private struct ClearFullScreenBackground: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}
