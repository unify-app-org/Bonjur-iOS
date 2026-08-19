//
//  AuthOptionalSelectGenderView.swift
//  AppAuthImpl
//
//  Created by Huseyn Hasanov on 28.12.25.
//

import SwiftUI
import AppUIKit
import AppFoundation

struct AuthOptionalSelectGenderView: View {
    @EnvironmentObject var store: StoreOf<AuthOptionalInfoFeature>

    var body: some View {
        VStack(spacing: 16) {
            topView
            gendersView
        }
        .padding(.horizontal)
        .onTapGesture {
            store.send(.closeKeyboard)
        }
    }
    
    private var topView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("auth_gender_title".localized)
                .font(Font.Typography.TitleXl.extraBold)
                .foregroundStyle(Color.Palette.black)
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
            Text("auth_gender_subtitle".localized)
                .font(Font.Typography.BodyTextMd.regular)
                .foregroundStyle(Color.Palette.grayPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
        }
    }
    
    private var gendersView: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(store.state.genders, id: \.uuid) { language in
                    SelectableListItemView(model: language)
                        .onTapGesture {
                            store.send(.selectedGender(language.id))
                        }
                }
            }
        }
    }
}

#Preview {
    AuthOptionalSelectGenderView()
}
