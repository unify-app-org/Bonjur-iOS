//
//  OnboardingView.swift
//  AppAuth
//
//  Created by Huseyn Hasanov on 23.12.25.
//

import SwiftUI
import AppFoundation
import AppUIKit

struct OnboardingView: View {
    @ObservedObject var store: StoreOf<OnboardingFeature>
    @State private var currentPage = 0

    init(store: StoreOf<OnboardingFeature>, currentPage: Int = 0) {
        self.store = store
        self.currentPage = currentPage
    }
    
    var body: some View {
        VStack {
            topView
            tabView
            buttons
        }
        .onAppear {
            currentPage = 0
            store.send(.fetchData)
        }
        .navigationBarHidden(true)
    }
    
    private var topView: some View {
        ZStack {
            if currentPage > 0 {
                HStack {
                    Button {
                        withAnimation {
                            currentPage -= 1
                        }
                    } label: {
                        Image(uiImage: UIImage.Icons.arrowLeft01)
                            .frame(width: 28)
                    }
                    Spacer()
                }
            }
            
            HStack {
                Spacer()
                Image(uiImage: UIImage.Icons.logoWithText)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 105, height: 32)
                Spacer()
            }
        }
        .frame(height: 44)
        .padding(.horizontal)
    }
    
    private var tabView: some View {
        AppTabView(
            currentPage: $currentPage,
            pageCount: store.state.uiModel.count
        ) {
            ForEach(
                Array(store.state.uiModel.enumerated()),
                id: \.element.id
            ) { index, model in
                itemView(model)
                    .tag(index)
            }
        }
        .padding(.bottom, 20)
    }
    
    private var buttons: some View {
        HStack {
            AppButton(
                title: "Skip",
                model: .init(type: .tertiary)
            ) {
                store.send(.skipOnboarding)
            }
            AppButton(
                title: "Next",
                model: .init(contentSize: .fill)
            ) {
                withAnimation {
                    if currentPage - 1 < store.state.uiModel.count {
                        currentPage += 1
                    }
                    if currentPage >= store.state.uiModel.count {
                        store.send(.skipOnboarding)
                    }
                }
            }
        }
        .padding(.horizontal)
    }
    
    private func itemView(
        _ model: OnboardingUIModel
    ) -> some View {
        VStack(alignment: .leading) {
            Text(model.title)
                .font(Font.Typography.TitleXl.extraBold)
                .padding(.horizontal)
            Text(model.subtitle)
                .font(Font.Typography.BodyTextMd.regular)
                .foregroundStyle(Color.Palette.grayPrimary)
                .padding(.horizontal)
            Image(uiImage: model.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity)
            Spacer()
        }
    }
}
