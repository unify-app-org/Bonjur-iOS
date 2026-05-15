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
            title: "Which language do you know?",
            subtitle: "Select languages you know",
            showsBackButton: false,
            showsDoneButton: false
        )
    }
}

#Preview {
    AuthOptionalSelectLanguageView()
}
