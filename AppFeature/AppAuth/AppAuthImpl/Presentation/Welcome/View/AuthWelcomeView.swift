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
            backButton
            itemView
            buttons
        }
        .onAppear {
            store.send(.fetchData)
        }
    }
    
    private var backButton: some View {
        HStack{
            Button{
                store.send(.dismiss)
            } label: {
                Image(uiImage: UIImage.Icons.xmark)
                    .padding()
            }
            Spacer()
        }
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
    }
    
    private var buttons: some View {
        HStack {
            AppButton(
                title: "Skip",
                model: .init(type: .tertiary)
            ) {
                
            }
            AppButton(
                title: "Continue",
                model: .init(contentSize: .fill)
            ) {
                store.send(.continueTapped)
            }
        }
        .padding(.horizontal)
    }
}
