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
    
    private var viewSteps: [AuthOptionalInfoViewState.StepItem] {
        [
            .init(
                id: 1,
                view: AnyView(
                    AuthOptionalBirthdayView()
                        .environmentObject(store)
                )
            ),
            .init(
                id: 2,
                view: AnyView(
                    AuthOptionalSelectGenderView()
                        .environmentObject(store)
                )
            ),
            .init(
                id: 3,
                view: AnyView(
                    AuthOptionalSelectLanguageView()
                        .environmentObject(store)
                )
            ),
            .init(
                id: 4,
                view: AnyView(
                    AuthOptionalBioView()
                        .environmentObject(store)
                )
            )
        ]
    }
    
    var body: some View {
        VStack {
            topView
            midView
            bottomView
        }
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
        .onAppear {
            store.send(.fetchData)
        }
    }
    
    private var topView: some View {
        ZStack {
            HStack {
                Button {
                    if store.state.currentStep != 1 {
                        store.state.currentStep -= 1
                    } else {
                        
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
                    currentStep: store.state.currentStep,
                    totalSteps: viewSteps.count
                )
                .padding(.horizontal, 32)
                Spacer()
            }
        }
        .frame(height: 44)
        .padding(.horizontal)
    }
    
    private var midView: some View {
        TabView(selection: $store.state.currentStep) {
            ForEach(viewSteps) { step in
                step.view
                    .tag(step.id)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .animation(.easeInOut, value: store.state.currentStep)
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
                store.state.currentStep += 1
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 8)
    }
}
