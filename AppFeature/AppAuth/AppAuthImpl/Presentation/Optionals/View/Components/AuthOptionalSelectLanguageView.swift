//
//  AuthOptionalSelectLanguageView.swift
//  AppAuthImpl
//
//  Created by Huseyn Hasanov on 28.12.25.
//

import SwiftUI
import AppUIKit
import AppFoundation

struct AuthOptionalSelectLanguageView: View {
    @EnvironmentObject var store: StoreOf<AuthOptionalInfoFeature>

    var body: some View {
        VStack(spacing: 16) {
            topView
            SearchView(text: .constant(""))
            listView
        }
        .padding(.horizontal)
    }
    
    private var topView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Which language do you know?")
                .font(Font.Typography.TitleXl.extraBold)
                .foregroundStyle(Color.Palette.black)
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
            Text("Select languages you know")
                .font(Font.Typography.BodyTextMd.regular)
                .foregroundStyle(Color.Palette.grayPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
        }
    }
    
    private var listView: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(Array(store.state.langauges.enumerated()), id: \.element.id) { index, language in
                    SelectableListItemView(model: language)
                        .onTapGesture {
                            store.send(.selectedLanguage(index))
                        }
                }
            }
        }
    }
}

#Preview {
    AuthOptionalSelectLanguageView()
}
