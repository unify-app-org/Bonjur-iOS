//
//  CardBackgroundView.swift
//  AppCore
//
//  Created by Huseyn Hasanov on 14.01.26.
//
import SwiftUI

public struct CardBackgroundView<Content: View>: View {
    let content: () -> Content
    var backgroundColor: Color = Color.Palette.primary
    var circleStrokeColor: Color = .white.opacity(0.5)
    var strokeWidth: CGFloat = 40
    var cornerRadius: CGFloat = 20
    
    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    public var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(backgroundColor)
            
            GeometryReader { geometry in
                Circle()
                    .stroke(circleStrokeColor, lineWidth: strokeWidth)
                    .frame(
                        width: geometry.size.width * 0.4,
                        height: geometry.size.width * 0.6
                    )
                    .position(
                        x: geometry.size.width * 0.6,
                        y: -geometry.size.width * 0.05
                    )
                
                Circle()
                    .stroke(circleStrokeColor, lineWidth: strokeWidth)
                    .frame(
                        width: geometry.size.width * 0.4,
                        height: geometry.size.width * 0.55
                    )
                    .position(
                        x: geometry.size.width * 0.3,
                        y: geometry.size.height + geometry.size.width * 0.05
                    )
            }
            
            content()
                .padding()
        }
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        .clipped()
    }
}

public extension CardBackgroundView {
    func background(_ color: Color) -> Self {
        var view = self
        view.backgroundColor = color
        return view
    }
    
    func circleStroke(_ color: Color) -> Self {
        var view = self
        view.circleStrokeColor = color.opacity(0.4)
        return view
    }
    
    func strokeWidth(_ width: CGFloat) -> Self {
        var view = self
        view.strokeWidth = width
        return view
    }
    
    func cornerRadius(_ radius: CGFloat) -> Self {
        var view = self
        view.cornerRadius = radius
        return view
    }
}
