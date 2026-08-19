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
                title: "auth_sign_in_button".localized,
                model: .init(
                    contentSize: .fill
                )
            ) {
                store.send(.signIn)
            }
            .disabled(!store.state.isValid)
        }
        .padding()
        .onAppear {
            store.send(.fetchData)
        }
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
        .appErrorAlert(
            alert: $store.state.error
        )
        .localized()
    }
    
    private var txtfieldsView: some View {
        VStack(spacing: 16) {
            AppTextField(
                text: $store.state.email,
                placeHolder: "auth_email_placeholder".localized,
                model: .init(
                    title: "auth_email".localized,
                    keyboardType: .emailAddress
                )
            )
            AppTextField(
                text: $store.state.password,
                placeHolder: "auth_password_placeholder".localized,
                model: .init(
                    title: "auth_password".localized,
                    type: .secure,
                )
            )
        }
    }
    
    private var topView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("auth_sign_in_title".localized)
                .font(Font.Typography.TitleXl.extraBold)
                .foregroundStyle(Color.Palette.black)
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
            Text("auth_sign_in_subtitle".localized)
                .font(Font.Typography.BodyTextMd.regular)
                .foregroundStyle(Color.Palette.grayPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
        }
    }
}
