//
//  AuthOptionalBioView.swift
//  AppAuthImpl
//
//  Created by Huseyn Hasanov on 28.12.25.
//

import SwiftUI
import AppFoundation
import AppUIKit

struct AuthOptionalBioView: View {
    @EnvironmentObject var store: StoreOf<AuthOptionalInfoFeature>

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                topView
                TextView(text: $store.state.biography)
                    .frame(height: 230)
            }
        }
        .padding(.horizontal)
    }
    
    
    private var topView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("About you")
                .font(Font.Typography.TitleXl.extraBold)
                .foregroundStyle(Color.Palette.black)
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
            Text("Write something about yourself")
                .font(Font.Typography.BodyTextMd.regular)
                .foregroundStyle(Color.Palette.grayPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
        }
    }
}

#Preview {
    AuthOptionalBioView()
}
