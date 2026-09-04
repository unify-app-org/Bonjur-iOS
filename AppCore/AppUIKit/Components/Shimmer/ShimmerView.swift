//
//  ShimmerView.swift
//  AppUIKit
//
//  Created by Huseyn Hasanov on 04.09.26.
//

import SwiftUI

/// Skeleton placeholders with a sweeping highlight — the "content is coming"
/// state for a screen that owns its whole layout, as opposed to `AppLoadingUI`,
/// which is a blocking overlay for an action the user must wait out.
///
///     ShimmerBox(cornerRadius: 20)
///         .frame(height: 184)
///
/// Mirrors Android `ShimmerBox` / `rememberShimmerBrush`.
public struct ShimmerBox: View {

    private let cornerRadius: CGFloat

    public init(cornerRadius: CGFloat = 8) {
        self.cornerRadius = cornerRadius
    }

    public var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .fill(Color.Palette.onBackground)
            .shimmering(cornerRadius: cornerRadius)
    }
}

public extension View {
    /// Sweeps a soft highlight across the view. `cornerRadius` must match the
    /// shape underneath — the sweep is clipped to it, otherwise the highlight
    /// runs over the rounded corners.
    func shimmering(
        active: Bool = true,
        cornerRadius: CGFloat = 8
    ) -> some View {
        modifier(ShimmerModifier(active: active, cornerRadius: cornerRadius))
    }
}

private struct ShimmerModifier: ViewModifier {

    let active: Bool
    let cornerRadius: CGFloat

    /// Fraction of the sweep band's travel, `-1` (fully off the leading edge) to `1`.
    @State private var phase: CGFloat = -1

    func body(content: Content) -> some View {
        if active {
            content
                .overlay {
                    GeometryReader { geometry in
                        // The band is wider than the view so the highlight travels all
                        // the way through instead of popping in at one edge.
                        let bandWidth = geometry.size.width * Self.bandScale
                        LinearGradient(
                            colors: [
                                .clear,
                                Color.Palette.white.opacity(0.9),
                                .clear
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .frame(width: bandWidth)
                        .offset(x: phase * (geometry.size.width + bandWidth) / 2)
                    }
                    .allowsHitTesting(false)
                }
                .clipShape(
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                )
                .onAppear {
                    withAnimation(
                        .linear(duration: Self.sweepDuration).repeatForever(autoreverses: false)
                    ) {
                        phase = 1
                    }
                }
        } else {
            content
        }
    }

    private static let sweepDuration: TimeInterval = 1.3
    private static let bandScale: CGFloat = 0.8
}
