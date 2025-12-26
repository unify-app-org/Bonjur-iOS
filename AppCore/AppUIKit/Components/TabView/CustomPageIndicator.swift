//
//  CustomPageIndicator.swift
//  AppCore
//
//  Created by Huseyn Hasanov on 26.12.25.
//

import SwiftUI

struct CustomPageIndicator: View {
    let numberOfPages: Int
    let currentPage: Int
    let maxVisibleDots: Int = 5
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<numberOfPages, id: \.self) { index in
                let isVisible = shouldShowDot(index: index)
                
                if isVisible {
                    Capsule()
                        .fill(index == currentPage ? Color.Palette.primary : Color.gray.opacity(0.3))
                        .frame(
                            width: dotWidth(for: index),
                            height: dotHeight(for: index)
                        )
                        .opacity(dotOpacity(for: index))
                        .scaleEffect(dotScale(for: index))
                        .animation(.easeInOut(duration: 0.3), value: currentPage)
                }
            }
        }
    }
    
    private func shouldShowDot(index: Int) -> Bool {
        if numberOfPages <= maxVisibleDots {
            return true
        }
        
        let distance = abs(currentPage - index)
        return distance <= 2
    }
    
    private func dotWidth(for index: Int) -> CGFloat {
        if numberOfPages >= 5 {
            if index == currentPage {
                return 32
            }
            
            let distance = abs(currentPage - index)
            if distance == 1 {
                return 14
            } else if distance == 2 {
                return 12
            }
            return 7
        } else {
            if index == currentPage {
                return 32
            } else {
                return 14
            }
        }
    }
    
    private func dotHeight(for index: Int) -> CGFloat {
        let distance = abs(currentPage - index)
        if numberOfPages >= 5 {
            if distance == 0 {
                return 8
            } else if distance == 1 {
                return 8
            } else if distance == 2 {
                return 6
            }
            return 4
        } else {
            return 8
        }
    }
    
    private func dotOpacity(for index: Int) -> Double {
        let distance = abs(currentPage - index)
        if numberOfPages >= 5 {
            if distance == 0 {
                return 1.0
            } else if distance == 1 {
                return 0.6
            } else if distance == 2 {
                return 0.3
            }
            return 0.2
        } else {
            return 1
        }
    }
    
    private func dotScale(for index: Int) -> CGFloat {
        let distance = abs(currentPage - index)
        if numberOfPages >= 5 {
            if distance <= 1 {
                return 1.0
            } else if distance == 2 {
                return 0.8
            }
            return 0.6
        } else {
            return 1.0
        }
    }
}
