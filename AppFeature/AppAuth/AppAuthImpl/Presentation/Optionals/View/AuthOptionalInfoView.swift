//
//  AuthOptionalInfoView.swift
//  AppAuthImpl
//
//  Created by Huseyn Hasanov on 26.12.25.
//

import SwiftUI
import AppFoundation
import AppUIKit

struct AuthOptionalInfoView: View {
    @ObservedObject var store: StoreOf<AuthOptionalInfoFeature>
    @State private var currentStep: Int = 1
    
    var body: some View {
        VStack {
            topView
            midView
            bottomView
        }
    }
    
    private var topView: some View {
        ZStack {
            HStack {
                Button {
                    withAnimation {
                        if currentStep != 1 {
                            currentStep -= 1
                        } else {
                            
                        }
                    }
                } label: {
                    Image(uiImage: UIImage.Icons.arrowLeft01)
                        .frame(width: 28)
                }
                Spacer()
            }
            
            HStack {
                Spacer()
                AppProgressView(
                    currentStep: currentStep,
                    totalSteps: 3
                )
                .padding(.horizontal, 32)
                Spacer()
            }
        }
        .frame(height: 44)
        .padding(.horizontal)
    }
    
    private var midView: some View {
        TabView(selection: $currentStep) {
            Text("Test")
                .tag(1)
            Text("Test2")
                .tag(2)
            Text("Test3")
                .tag(3)
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
    }
    
    private var bottomView: some View {
        HStack {
            AppButton(
                title: "Skip",
                model: .init(type: .tertiary)
            ) {
                
            }
            AppButton(
                title: "Next",
                model: .init(contentSize: .fill)
            ) {
                withAnimation {
                    currentStep += 1
                }
            }
        }
        .padding(.horizontal)
    }
}
