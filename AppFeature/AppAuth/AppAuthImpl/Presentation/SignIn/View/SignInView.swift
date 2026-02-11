//
//  SignInView.swift
//  AppAuthImpl
//
//  Created by Huseyn Hasanov on 06.01.26.
//

import SwiftUI
import AppUIKit
import AppFoundation

struct SignInView: View {
    @ObservedObject var store: StoreOf<SignInFeature>
    
    var body: some View {
        VStack(spacing: 28) {
            topView
            txtfieldsView
            Spacer()
            AppButton(
                title: "Sign in",
                model: .init(
                    contentSize: .fill
                )
            ) {
                store.send(.signIn)
            }
        }
        .padding()
        .onAppear {
            store.send(.fetchData)
        }
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
    }
    
    private var txtfieldsView: some View {
        VStack(spacing: 16) {
            AppTextField(
                text: $store.state.email,
                placeHolder: "Enter your email",
                model: .init(
                    title: "Email",
                    keyboardType: .emailAddress
                )
            )
            AppTextField(
                text: $store.state.password,
                placeHolder: "Enter your password",
                model: .init(
                    title: "Password",
                    type: .secure,
                )
            )
        }
    }
    
    private var topView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Sign In")
                .font(Font.Typography.TitleXl.extraBold)
                .foregroundStyle(Color.Palette.black)
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
            Text("Only continue if you downloaded the app from a store or website that you trust.")
                .font(Font.Typography.BodyTextMd.regular)
                .foregroundStyle(Color.Palette.grayPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
        }
    }
}
