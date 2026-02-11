//
//  AuthOptionalInterestsView.swift
//  AppAuthImpl
//
//  Created by Huseyn Hasanov on 30.12.25.
//

import SwiftUI
import AppFoundation
import AppUIKit

struct AuthOptionalInterestsView: View {
    @EnvironmentObject var store: StoreOf<AuthOptionalInfoFeature>

    var body: some View {
        VStack(spacing: 16) {
            topView
            SearchView(text: .constant(""))
            list
        }
        .padding()
    }
    
    private var topView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Your Interest")
                .font(Font.Typography.TitleXl.extraBold)
                .foregroundStyle(Color.Palette.black)
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
            Text("Choose what you’re interested in")
                .font(Font.Typography.BodyTextMd.regular)
                .foregroundStyle(Color.Palette.grayPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
        }
    }
    
    @ViewBuilder
    private var list: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(alignment: .leading, spacing: 16) {
                ForEach(store.state.interests, id: \.id) { section in
                    Text(section.title)
                        .foregroundStyle(Color.Palette.blackHigh)
                        .font(Font.Typography.BodyTextMd.semiBold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    FlowLayout(spacing: 12, items: section.interests) { item in
                        CategoriesChipsView(model: item)
                            .onTapGesture {
                                store.send(.selectedInterest(item.id))
                            }
                    }
                }
            }
        }
    }
    
}

#Preview {
    AuthOptionalInterestsView()
}
