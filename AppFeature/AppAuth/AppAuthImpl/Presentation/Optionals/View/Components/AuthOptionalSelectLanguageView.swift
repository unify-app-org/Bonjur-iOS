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
        SelectableListView(
            items: $store.state.langauges,
            title: "auth_languages_title".localized,
            subtitle: "auth_languages_subtitle".localized,
            showsBackButton: false,
            showsDoneButton: false
        )
    }
}

#Preview {
    AuthOptionalSelectLanguageView()
}
