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
    
    var body: some View {
        ZStack {
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    store.send(.closeKeyboard)
                    store.send(.closeDatePicker)
                }
            VStack {
                topView
                midView
                bottomView
                
                if store.state.showDatePicker {
                    datePickerOverlay
                }
            }
        }
        .animation(
            .spring(response: 0.25, dampingFraction: 0.8),
            value: store.state.showDatePicker
        )
        .onAppear {
            store.send(.fetchData)
        }
    }
    
    private var topView: some View {
        HStack(spacing: 25) {
            AppProgressView(
                currentStep: store.state.currentStep,
                totalSteps: store.state.getAllViews(store: store).count
            )
            
            Button {
                store.send(.skipTapped)
            } label: {
                Image(uiImage: UIImage.Icons.xmark)
                    .frame(width: 28)
            }
        }
        .frame(height: 44)
        .padding(.horizontal)
    }
    
    private var midView: some View {
        TabView(selection: $store.state.currentStep) {
            ForEach(store.state.getAllViews(store: store)) { step in
                step.view
                    .tag(step.id)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .animation(.easeInOut, value: store.state.currentStep)
    }
    
    private var datePickerOverlay: some View {
        DatePicker(
            "Select Date",
            selection: Binding(
                get: { store.state.birthDate ?? Date() },
                set: { store.state.birthDate = $0 }
            ),
            displayedComponents: .date
        )
        .datePickerStyle(.wheel)
        .labelsHidden()
        .scaleEffect(x: 1.1, y: 1.1)
    }
    
    private var bottomView: some View {
        HStack {
            if store.state.currentStep > 1 {
                AppButton(
                    title: "Back",
                    model: .init(type: .tertiary)
                ) {
                    store.send(.previouseTapped)
                }
            }
            AppButton(
                title: "Next",
                model: .init(contentSize: .fill)
            ) {
                store.send(.nextTapped)
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 8)
    }
}
