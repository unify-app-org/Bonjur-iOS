//
//  OverlayView.swift
//  App
//
//  Created by Huseyn Hasanov on 11.01.26.
//  Copyright © 2026 Unify. All rights reserved.
//

import UIKit
import SwiftUI

final class OverlayView: UIView {
    var highlightFrame: CGRect = .zero {
        didSet {
            setNeedsDisplay()
        }
    }
    var highlightCornerRadius: CGFloat = 0
    var onTapGesture: (() -> Void)?
    var allowTapToAdvance: Bool = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTapGesture()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTapGesture()
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tapGesture.cancelsTouchesInView = false
        addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        guard allowTapToAdvance else { return }
        
        let location = gesture.location(in: self)
        
        if !isPointInHighlightArea(location) {
            onTapGesture?()
        }
    }
    
    private func isPointInHighlightArea(_ point: CGPoint) -> Bool {
        let path = UIBezierPath(
            roundedRect: highlightFrame,
            cornerRadius: highlightCornerRadius
        )
        return path.contains(point)
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        context.setFillColor(UIColor(Color.Palette.blackHigh).withAlphaComponent(0.4).cgColor)
        context.fill(rect)
        
        context.setBlendMode(.clear)
        
        let highlightPath = UIBezierPath(
            roundedRect: highlightFrame,
            cornerRadius: highlightCornerRadius
        )
        highlightPath.fill()
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if isPointInHighlightArea(point) {
            return nil
        }
        
        return super.hitTest(point, with: event)
    }
}
