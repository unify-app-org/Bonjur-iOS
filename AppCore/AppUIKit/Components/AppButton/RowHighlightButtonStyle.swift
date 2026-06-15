//
//  RowHighlightButtonStyle.swift
//  AppCore
//
//  Highlights a tappable info row with a subtle background fill while pressed.
//  Used by detail-screen actionable rows (phone / link) so taps feel responsive.
//

import SwiftUI

public struct RowHighlightButtonStyle: ButtonStyle {
    public init() {}

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical, 6)
            .padding(.horizontal, 8)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.Palette.grayQuaternary)
                    .opacity(configuration.isPressed ? 1 : 0)
            )
            // Keep surrounding layout unchanged; the padding only enlarges the
            // highlight + hit area, not the resting position of the content.
            .padding(.vertical, -6)
            .padding(.horizontal, -8)
            .contentShape(Rectangle())
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}
