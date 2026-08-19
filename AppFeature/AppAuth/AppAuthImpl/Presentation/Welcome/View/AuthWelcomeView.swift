//
//  AuthWelcomeView.swift
//  AppAuthImpl
//
//  Created by Huseyn Hasanov on 26.12.25.
//

import SwiftUI
import AppFoundation
import AppUIKit

struct AuthWelcomeView: View {
    @ObservedObject var store: StoreOf<AuthWelcomeFeature>
    
    var body: some View {
        VStack {
            itemView
            buttons
        }
        .onAppear {
            store.send(.fetchData)
        }
        .localized()
    }
    
    private var itemView: some View {
        VStack(alignment: .leading) {
            Text(store.state.uiModel.title)
                .font(Font.Typography.TitleXl.extraBold)
                .padding(.horizontal)
            Text(store.state.uiModel.subtitle)
                .font(Font.Typography.BodyTextMd.regular)
                .foregroundStyle(Color.Palette.grayPrimary)
                .padding(.horizontal)
            Image(uiImage: store.state.uiModel.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity)
            Spacer()
        }
        .padding(.top, 16)
    }
    
    private var buttons: some View {
        VStack {
            AppButton(
                title: "auth_continue".localized,
                model: .init(contentSize: .fill)
            ) {
                store.send(.continueTapped)
            }
            
            AppButton(
                title: "auth_skip".localized,
                model: .init(type: .tertiary, contentSize: .fill)
            ) {
                store.send(.skipTapped)
            }
        }
        .padding(.horizontal)
    }
}
