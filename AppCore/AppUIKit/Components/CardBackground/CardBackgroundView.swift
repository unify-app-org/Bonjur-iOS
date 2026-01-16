//
//  CardBackgroundView.swift
//  AppCore
//
//  Created by Huseyn Hasanov on 14.01.26.
//
import SwiftUI

public struct CardBackgroundView<Content: View>: View {
    let content: () -> Content
    var cardType: BackgroundType
    var bgColorType: AppUIEntities.BackgroundType = .primary
    var circleStrokeColor: Color = .Palette.white.opacity(0.5)
    var strokeWidth: CGFloat = 40
    var cornerRadius: CGFloat = 20
    
    public init(
        cardType: BackgroundType = .community,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.content = content
        self.cardType = cardType
    }
    
    public var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(bgColorType.bgColor)
            
            GeometryReader { geometry in
                Circle()
                    .stroke(circleStrokeColor, lineWidth: strokeWidth)
                    .frame(
                        width: geometry.size.width * 0.4,
                        height: geometry.size.width * 0.6
                    )
                    .position(
                        x: geometry.size.width * (cardType == .community ? 0.6 : 0.8),
                        y: -geometry.size.width * 0.05
                    )
                
                if cardType == .community {
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
            }
            
            content()
        }
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        .clipped()
    }
}

public extension CardBackgroundView {
    func backgroundType(_ type: AppUIEntities.BackgroundType) -> Self {
        var view = self
        view.bgColorType = type
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

public extension CardBackgroundView {
    enum BackgroundType {
        case community
        case club
    }
}


#Preview {
    CardBackgroundExample()
}
