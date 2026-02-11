//
//  ProgressView.swift
//  AppCore
//
//  Created by Huseyn Hasanov on 26.12.25.
//


import SwiftUI

public struct AppProgressView: View {
    let currentStep: Int
    let totalSteps: Int
    
    var progress: CGFloat {
        CGFloat(currentStep) / CGFloat(totalSteps)
    }
    
    public init(currentStep: Int, totalSteps: Int) {
        self.currentStep = currentStep
        self.totalSteps = totalSteps
    }
    
    public var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.Palette.grayTeritary.opacity(0.3))
                    .frame(height: 20)
                
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.Palette.primary)
                    .frame(width: geometry.size.width * progress, height: 20)
            }
        }
        .frame(height: 20)
    }
}
